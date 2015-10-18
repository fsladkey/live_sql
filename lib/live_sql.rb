require "live_sql/version"
require "live_sql/interface"
require 'singleton'
require 'sqlite3'
require 'table_print'
require 'colorize'


class QuestionsDatabase < SQLite3::Database

  def initialize(db)
    super(db)

    self.results_as_hash = true
    self.type_translation = true
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

  def initialize(db)
    @interface = Interface.new
    @db = QuestionsDatabase.new(db)

    @string = " "
    @result = []

    @move = :invalid
    @cursor_pos = 0
    @errors = []
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
    else
      @string.insert(@cursor_pos, input)
      @cursor_pos += 1
      attempt_to_query_db
    end
  end

  def attempt_to_query_db
    old_table = @result
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
    @db.execute(<<-SQL)
      #{string}
      LIMIT 30
    SQL
  end

end
