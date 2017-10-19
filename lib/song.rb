require_relative "../config/environment.rb"
require 'active_support/inflector'

class Song


  def self.table_name #finds the name of the corresponding table
    self.to_s.downcase.pluralize
  end

  def self.column_names #finds that table's column name
    DB[:conn].results_as_hash = true #returns an array of hashes (column names = keys), each hash is a column

    sql = "pragma table_info('#{table_name}')" #each hash returns info about one column specifically

    table_info = DB[:conn].execute(sql) #defines hash output as table_info
    column_names = []
    table_info.each do |row| #iterates over the table_info hash and shovels the names into column_names array
      column_names << row["name"]
    end
    column_names.compact #removes all nil values
  end

  self.column_names.each do |col_name| #iterate over the column_names method (array)
    attr_accessor col_name.to_sym #defines accessor methods to each name and converts to a symbol
  end

  def initialize(options={}) #defines options as an empty hash
    options.each do |property, value|
      self.send("#{property}=", value) #define/invoke methods for each key/value pair and set the key equal to the value
    end
  end

  def save #saves a new row in the database table
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end

  def table_name_for_insert
    self.class.table_name #calls a Class Method inside of an instance method
  end

  def values_for_insert #selects the values to be inserted into a new row of the table
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
  end

  def col_names_for_insert #deletes the id from the column_names array and joins the elements into a comma seperated list
    self.class.column_names.delete_if {|col| col == "id"}.join(", ")
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM #{self.table_name} WHERE name = '#{name}'"
    DB[:conn].execute(sql)
  end

end
