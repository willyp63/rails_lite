require_relative 'db_connection'
require 'active_support/inflector'

class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    class_name.pluralize.underscore
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @name = name
    defaults = { class_name: name.to_s.camelcase,
                 primary_key: :id,
                 foreign_key: "#{name}_id".to_sym}
    options = defaults.merge(options)

    @foreign_key = options[:foreign_key]
    @primary_key = options[:primary_key]
    @class_name = options[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @name = name
    defaults = { class_name: name.to_s.singularize.camelcase,
                 primary_key: :id,
                 foreign_key: "#{self_class_name.downcase}_id".to_sym}
    options = defaults.merge(options)

    @foreign_key = options[:foreign_key]
    @primary_key = options[:primary_key]
    @class_name = options[:class_name]
  end
end

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(name) do
      foreign_key = send(options.foreign_key)
      options.model_class.where(options.primary_key => foreign_key).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      primary_key = send(options.primary_key)
      options.model_class.where(options.foreign_key => primary_key)
    end
  end

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name]
    define_method(name) do
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.model_class.table_name
      source_table = source_options.model_class.table_name
      foreign_key = send(through_options.foreign_key)

      results = DBConnection.execute(<<-SQL, foreign_key)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
          ON
            #{through_table}.#{source_options.foreign_key} =
            #{source_table}.#{source_options.primary_key}
        WHERE
          #{through_table}.#{through_options.primary_key} = ?
      SQL
      results.map {|result_hash| source_options.model_class.new(result_hash)}.first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end
