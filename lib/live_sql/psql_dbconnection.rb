require 'pg'

class PostgresqlDatabaseConnection

  def initialize(db)
    @connection = PG.connect(dbname: db)
    @connection.type_map_for_results = PG::BasicTypeMapForResults.new @connection
  end

  def execute
    results = []
    result = @connection.exec(arg)
    result.each_row do |row|
      results << Hash[result.fields.zip(row)]
    end
    results
  end
end
