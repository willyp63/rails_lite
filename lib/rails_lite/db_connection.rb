require 'sqlite3'
require 'active_support/inflector'

class DBConnection
  DB_NAME = Dir.pwd.scan(/\/([^\/]*)/).last[0].underscore
  DB_FILE = "db/" + DB_NAME + ".db"
  SQL_FILE = "db/" + DB_NAME + ".sql"

  def self.open
    @db = SQLite3::Database.new(DB_FILE)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm #{DB_FILE}",
      "cat #{SQL_FILE} | sqlite3 #{DB_FILE}"
    ]

    commands.each { |command| `#{command}` }
    DBConnection.open
  end

  def self.instance
    @db || DBConnection.open
  end

  def self.execute(*args)
    # print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    # print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end
  #
  # private
  #
  # def self.print_query(query, *interpolation_args)
  #   return unless PRINT_QUERIES
  #
  #   puts '--------------------'
  #   puts query
  #   unless interpolation_args.empty?
  #     puts "interpolate: #{interpolation_args.inspect}"
  #   end
  #   puts '--------------------'
  # end
end
