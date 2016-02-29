require_relative "./live_sql/version.rb"
require_relative "./live_sql/interface.rb"
require_relative "./live_sql/cursorable.rb"
require_relative "./live_sql/util.rb"
require_relative "./live_sql/sqlite3_dbconnection.rb"
require_relative "./live_sql/psql_dbconnection.rb"
require 'singleton'
require 'table_print'
require 'colorize'
require 'byebug'

class LiveSQL
  include Cursorable
  include Util

  attr_accessor :result

  def initialize(db, opts = {})
    debugger
    if opts[:db] == :sqlite
      @db = LiveSqlite3DatabaseConnection.new(db)
    else
      @db = PostgresqlDatabaseConnection.new(db)
      end
    end

    @interface = Interface.new
    @limit = 30
    @string = " "
    @result = []

    @state = :invalid
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

  private

  def handle_input(input)
    if input.is_a?(Symbol)
      send(input)
    else
      @string.insert(@cursor_pos, input)
      @cursor_pos += 1
      attempt_to_query_db
    end
  end

  def attempt_to_query_db
    old_table = result
    filter_aggregate_functions

    result = query_db(@string)
    @state = :valid
    rescue StandardError => e
      @errors << e.message
      @result = old_table
      @state = :invalid
  end

  def filter_aggregate_functions
    if if aggregate_func_names.any? { |func| @string.upcase.include?(func) } && (@string =~ /\;\s*$/).nil?
      raise "Aggregate queries must be terminated with a semi-colon"
    end
  end

  def query_db(string)
    return if string =~ /drop/i
    @query.(<<-SQL)
    #{string}
    LIMIT
      #{@limit}
    SQL
  end

  def print_display
    system("clear")
    puts "Enter a query!".underline.bold
    puts "Green is for a valid query, red for syntax error."
    puts "Queries using AVG() or COUNT() must be terminated with a semi-colon."
    puts "The table always shows the last valid query."
    puts "Press esc to quit."

    if @state == :invalid
      print_invalid_query
    else
      print_valid_query
    end
    print_table
  end

  def print_invalid_query
    print @string[0...@cursor_pos].colorize(:red)
    print @string[@cursor_pos].colorize(background: :cyan, color: :red)
    print @string[@cursor_pos + 1..-1].colorize(:red)
    puts
  end

  def print_valid_query
    print @string[0...@cursor_pos].colorize(:green)
    print @string[@cursor_pos].colorize(background: :cyan)
    print @string[@cursor_pos + 1..-1].colorize(:green)
    puts
  end

  def print_table
    tp @result
  end


end

if __FILE__ == $PROGRAM_NAME
  ls = LiveSQL.new(ARGV.pop).run
end
