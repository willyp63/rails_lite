require_relative 'db_connection'

module Searchable
  def where(params)
    parse_all DBConnection.execute(<<-SQL, *params.values)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
      WHERE
        #{where_clause(params)}
    SQL
  end

  private
  def where_clause(params)
    params.keys.map {|col| "#{col} = ?"}.join(' AND ')
  end
end
