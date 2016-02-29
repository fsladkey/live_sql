require "live_sql/version"
require "live_sql/interface"
require 'singleton'
require 'sqlite3'
require 'table_print'
require 'colorize'
require 'pg'
require 'byebug'

# # Output a table of current connections to the DB
# # conn = PG.connect( dbname: 'sales' )
# conn.exec( "SELECT * FROM pg_stat_activity" ) do |result|
#   puts "     PID | User             | Query"
#   result.each do |row|
#     puts " %7d | %-16s | %s " %
#       row.values_at('procpid', 'usename', 'current_query')
#   end
# end

class LiveSqlite3Database < SQLite3::Database

  def initialize(db)
    super(db)

    self.results_as_hash = true
    self.type_translation = true
  end
end


class DatabaseConnection

  def initialize
  end
end

class LiveSQL
  attr_accessor :result

  def self.run_default
    live_sql = LiveSQL.new('./live_sql/default_db/movie.db')
    live_sql.run
  end

  def self.run_with(db_name)
    live_sql = LiveSQL.new(db_name)
    live_sql.run
  end

  def initialize(db, opts)
    if opts[:db] == :sqlite
      @db = QuestionsDatabase.new(db)

      @query = Proc.new { |arg| @db.execute(arg) }
    else
      @db = PG.connect(dbname: db)
      @db.type_map_for_results = PG::BasicTypeMapForResults.new @db

      @query = Proc.new do |arg|
        results = []
        result = @db.exec(arg)
        result.each_row do |row|
          results << Hash[result.fields.zip(row)]
        end
        results
      end
    end

    @interface = Interface.new

    @string = " "
    @result = []

    @move = :invalid
    @cursor_pos = 0
    @errors = []
    puts "DONE"
  end

  def run
    while true
      print_display
      input = @interface.get_keyboard_input
      handle_input(input)
    end
  end

  def handle_input(input)
    if input == :abort
      system("clear")
      abort
    elsif input == :error
    elsif input == :right
      @cursor_pos += 1 unless @cursor_pos == @string.length - 1
    elsif input == :left
      @cursor_pos -= 1 unless @cursor_pos == 0
    elsif input == :backspace
      if @string.length > 1
        @string.slice!(@cursor_pos - 1)
        @cursor_pos -= 1 unless @cursor_pos == 0
      end
      attempt_to_query_db
    elsif input == :delete
      if @string.length > 1
        @string.slice!(@cursor_pos)
      end
    else
      @string.insert(@cursor_pos, input)
      @cursor_pos += 1
      attempt_to_query_db
    end
  end

  def attempt_to_query_db
    old_table = @result
    if (@string.downcase.include?("count") || @string.downcase.include?("avg")) && (@string =~ /\;\s*$/).nil?
      raise "Aggregate queries must be terminated with a semi-colon"
    end
    @result = query_db(@string)
    @mode = :valid
    rescue StandardError => e
      @errors << e.message
      @result = old_table
      @mode = :invalid
  end

  def print_display
    system("clear")
    puts "Enter a query!".underline.bold
    puts "Green is for a valid query, red for syntax error."
    puts "Queries using AVG() or COUNT() must be terminated with a semi-colon."
    puts "The table always shows the last valid query."
    puts "Press esc to quit."
    if @mode == :invalid
      print @string[0...@cursor_pos].colorize(:red)
      print @string[@cursor_pos].colorize(background: :cyan, color: :red)
      print @string[@cursor_pos + 1..-1].colorize(:red)
      puts
    else
      print @string[0...@cursor_pos].colorize(:green)
      print @string[@cursor_pos].colorize(background: :cyan)
      print @string[@cursor_pos + 1..-1].colorize(:green)
      puts
    end
    print_table
  end

  def print_table
    tp @result
  end

  def query_db(string)
    return if string =~ /drop/i
    @query.(<<-SQL)
      #{string}
      LIMIT 30
    SQL
  end

end
