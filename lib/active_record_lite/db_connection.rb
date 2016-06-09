require 'sqlite3'
require 'active_support/inflector'

class DBConnection
  # project folder name made underscore
  DB_NAME = Dir.pwd.scan(/\/([^\/]*)/).last[0].underscore

  DB_FILE = "db/" + DB_NAME + ".db"
  SQL_FILE = "db/" + DB_NAME + ".sql"

  def self.instance
    @db || open_db
  end

  def self.execute(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  def self.reset
    commands = [
      "rm #{DB_FILE}",
      "cat #{SQL_FILE} | sqlite3 #{DB_FILE}"
    ]
    # exececute commands in console
    commands.each { |command| `#{command}` }
    open_db
  end

  private
  def self.open_db
    @db = SQLite3::Database.new(DB_FILE)
    @db.results_as_hash = true
    @db.type_translation = true
    @db
  end
end
