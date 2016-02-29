require 'sqlite3'

class LiveSqlite3DatabaseConnection < SQLite3::Database

  def initialize(db)
    super(db)

    self.results_as_hash = true
    self.type_translation = true
  end
end
