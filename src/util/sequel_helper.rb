require 'sequel'

# a helper object that wraps sequel
# init and call its methods.
class SequelHelper
  
  attr_accessor :url, :user, :password, :db_name
  
  # need to pass all of the db args for the methods to work.
  def initialize(params = {})
    @url = params.fetch(:url)
    @user = params.fetch(:user)
    @password = params.fetch(:password)
    @db_name= params.fetch(:db_name)
    
    # connect to db.
    @db = Sequel.connect(:adapter => 'mysql', 
          :user => @user,
          :password=> @password, 
          :host => @url, 
          :database => @db_name)
  end
  
  # INSERT METHODS
  ############################################################################
  
  # basic insert.
  # return number of rows.
  def insert(table_name, param_hash)
    tab = @db.from(table_name).insert(param_hash)
    return true
  end
  
  # insert only if the where condition fails.
  # used if you want insert unique data.
  def insert_unique(table_name, insert_param)
    if !self.row_exist?(table_name, insert_param)
      tab = @db.from(table_name).insert(insert_param)
      return true
    else
      return false
    end
  end
  
  # READ METHODS
  ############################################################################
  
  # a simple read all method.
  # returns an array of hash.
  def read_all(table_name)
    tab = @db.from(table_name).all
    return tab
  end
  
  def read_where(table_name, params)
    tab = @db.from(table_name).where(params)
    tab_as_hash = self.to_array_of_hashes(tab)
    return tab_as_hash
  end
  
  # QUERY METHODS
  ############################################################################
  
  # a helper method that check if the where statement returns a row.
  # returns true if it does, else returns false
  def row_exist?(table_name, where_param)
    result = self.read_where(table_name, where_param)
    if result == nil || result.length == 0
      return false
    else
      return true
    end
  end
  
  # MISC METHODS
  ############################################################################
  
  # convert sequel results to an array of hashes.
  # in sequel, results are in its own data struct.
  # if you call all rows, it returns as an array of hashes.
  # if you do a where call, you can call this on the results
  # so it will return it as an array of hashes.
  def to_array_of_hashes(sequel_results)
    if sequel_results == nil
      return nil
    else
      result = Array.new
      sequel_results.each do |item|
        result.push(item)  
      end
      return result
    end
  end
  
  # TEST METHODS
  ############################################################################
  def self.hello
    return true
  end
  
end