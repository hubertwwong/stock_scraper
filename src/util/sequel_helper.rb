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
    #puts table_name
    #puts insert_param.inspect
    if !self.row_exist?(table_name, insert_param)
      tab = @db.from(table_name).insert(insert_param)
      return true
    else
      return false
    end
  end
  
  # insert a lot of stuff
  # take an array of hashes.
  def multiple(table_name, array_of_hashes)
    puts array_of_hashes.length.to_s + " items to save on table " + table_name
    array_of_hashes.each do |item|
      self.insert(table_name, array_of_hashes)
    end
    return true
  end
  
  # insert a lot of items.
  # returns false if an insert was not done.
  def multiple_unique(table_name, array_of_hashes)
    puts array_of_hashes.length.to_s + " items to save on table " + table_name 
    all_inserted = true
    array_of_hashes.each do |item|
      cur_row_inserted = self.insert_unique(table_name, item)
      all_inserted = cur_row_inserted && all_inserted 
    end
    return all_inserted
  end
  
  # READ METHODS
  ############################################################################
  
  # a simple read all method.
  # returns an array of hash.
  def read_all(table_name)
    tab = @db.from(table_name).all
    return tab
  end
  
  # takes 2 arguments. one is a table name and the other
  # is a param hash. sequel is smart enough to figure it out for you.
  def read_where(table_name, params)
    tab = @db.from(table_name).where(params)
    tab_as_hash = self.to_array_of_hashes(tab)
    return tab_as_hash
  end
  
  # takes 4 arguments. one is a table name and the other
  # is a param hash. sequel is smart enough to figure it out for you.
  # 
  # for the reverse flag, remember that default is ascending.
  # if you set the flag, it changes it to descending.
  # ascending. smallest to largest.
  #
  # order param takes a symbol....
  # params takes a hash. {:foo => "value", :bar => 1}
  def read_where_order(table_name, params, order_param, reverse_flag)
    if reverse_flag == false
      tab = @db.from(table_name).where(params).order(order_param)
    else
      tab = @db.from(table_name).where(params).order(order_param).reverse
    end
    tab_as_hash = self.to_array_of_hashes(tab)
    return tab_as_hash
  end
  
  # QUERY METHODS
  ############################################################################
  
  # a helper method that check if the where statement returns a row.
  # returns true if it does, else returns false
  def row_exist?(table_name, where_param)
    result = self.read_where(table_name, where_param)
    #puts "row_exists?"
    #puts table_name
    #puts where_param.inspect
    #puts result.inspect
    #puts result.to_s
    if result == nil || result.length == 0
      #puts 'row does not exist'
      return false
    else
      #puts 'row exist'
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