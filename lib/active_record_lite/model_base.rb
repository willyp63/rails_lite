require_relative 'searchable'
require_relative 'associatable'

class ModelBase
  extend Searchable
  extend Associatable

  def initialize(params = {})
    # check for valid attributes
    params.each do |attr_name, _|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
    end

    # set attributes
    params.each do |attr_name, value|
      send("#{attr_name}=", value)
    end
  end

  def self.finalize!
    columns.each do |column|
      # reader
      define_method(column) do
        attributes[column]
      end

      # writer
      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end

  def self.all
    parse_all DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL, id)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        id = ?
      LIMIT
        1
    SQL
    parse_all(results)[0]
  end

  def save
    id ? update : insert
  end

  def destroy
    DBConnection.execute(<<-SQL, id)
      DELETE FROM
        #{self.class.table_name}
      WHERE
        id = ?
    SQL
  end

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    DBConnection.execute(<<-SQL, *attribute_values[1..-1], id)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_setters}
      WHERE
        id = ?
    SQL
  end

  def self.columns
    @columns ||= fetch_columns
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map {|attr_name| send(attr_name)}
  end

  private
  def self.fetch_columns
    result = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    result[0].map(&:to_sym)
  end

  def self.parse_all(results)
    results.map {|result_hash| self.new(result_hash)}
  end

  def col_names
    self.class.columns.join(', ')
  end

  def col_setters
    self.class.columns[1..-1].map {|col| "#{col} = ?"}.join(', ')
  end

  def question_marks
    n = self.class.columns.count
    Array.new(n, '?').join(', ')
  end
end
