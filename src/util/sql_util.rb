require 'mysql'

class SqlUtil
  
  attr_accessor :url, :user, :password, :db_name
  
  # need to pass all of the db args for the methods to work.
  def initialize(params = {})
    @url = params.fetch(:url)
    @user = params.fetch(:user)
    @password = params.fetch(:password)
    @db_name= params.fetch(:db_name)
  end
  
  # INSERT METHODS
  ############################################################################
  # keep in mind that keys in the hash values must be strings.
  # they can't be symbols right now.
  # so { :foo => 'bar' } wont work.
  # and { 'foo' => 'bar' } works.
  
  # inserts a single row into db. 
  # takes a hash...
  # using replace to simplify some things.
  # not sure what its suppose to return..
  # just leave it to be false for now.
  def replace_one(table_name, vals)
    begin
      # "INSERT INTO Writers(Name) VALUES('Jack London')"
      con = Mysql.new(@url, @user, @password, @db_name)
      
      col_name = self.hash_get_keys_as_str(vals)
      col_vals = self.hash_get_values_as_str(vals)
      
      rs = con.query("REPLACE INTO " + table_name + " (" + col_name + ") VALUES (" + col_vals + ")")
      true
    rescue Mysql::Error => e
      self.print_error e
      false
    ensure
      con.close if con
    end
  end

  # READ METHODS
  ############################################################################
  
  # read all order by
  def read_all_order_by(table_name, order_name)
    result = []
    begin
      con = Mysql.new(@url, @user, @password, @db_name)
      rs = con.query("SELECT * FROM " + table_name + " ORDER BY " + order_name)
      n_rows = rs.num_rows
      n_rows.times do
        cur_row = rs.fetch_row
        result.push(self.hash_arrays(self.read_col_names(table_name), cur_row))
      end
        
      result
    rescue Mysql::Error => e
      self.print_error e
    ensure
      con.close if con
    end
  end
  
  # read all
  # take a a where param and a order param
  def read_all_one_param_order_by(table_name, col_name, col_val, order_name)
    result = []
    begin
      con = Mysql.new(@url, @user, @password, @db_name)
      rs = con.query("SELECT * FROM " + table_name + 
                      " WHERE " + col_name + "='" + col_val + "'" +
                      " ORDER BY " + order_name)
      n_rows = rs.num_rows
      n_rows.times do
        cur_row = rs.fetch_row
        result.push(self.hash_arrays(self.read_col_names(table_name), cur_row))
      end
        
      result
    rescue Mysql::Error => e
      self.print_error e
    ensure
      con.close if con
    end
  end
  
  # reads the last row of a given table.
  # sort by column name.
  # will use this to resume the scraper to determine where you left off.
  # it returns an array of values.
  def read_last_row(table_name, col_name)
    begin
      con = Mysql.new(@url, @user, @password, @db_name)
      rs = con.query("SELECT * FROM " + table_name + " ORDER BY " + col_name + " DESC")
      result = rs.fetch_row
      #puts result.inspect
      self.hash_arrays(self.read_col_names(table_name), result)
    rescue Mysql::Error => e
      self.print_error e
    ensure
      con.close if con
    end
  end

  # read a single where condition and returns a row.
  # useful for the zip retrival.
  # probably can add a hash later
  def read_with_one_param(table_name, col_name, col_val)
    begin
      con = Mysql.new(@url, @user, @password, @db_name)
      rs = con.query("SELECT * FROM " + table_name + " WHERE " + col_name + "='" + col_val + "'")
      result = rs.fetch_row
      #puts result.inspect
      self.hash_arrays(self.read_col_names(table_name), result)
    rescue Mysql::Error => e
      self.print_error e
    ensure
      con.close if con
    end
  end
  
  # a simple helper to read column names.
  # used later to tag array results with column names.
  # so the results will be easier to work with.
  def read_col_names(table_name)
    begin
      con = Mysql.new(@url, @user, @password, @db_name)
      
      # stores results.
      col_names = []
      
      rs = con.query("SELECT * FROM " + table_name)
      rs.fetch_fields.each_with_index do |info, i|
        col_names.push info.name
      end
      
      col_names
    rescue Mysql::Error => e
      self.print_error e
    ensure
      con.close if con
    end
  end

  # HELPER METHODS
  ############################################################################
  
  # debug method.
  def num_rows(table_name)
    begin
      con = Mysql.new(@url, @user, @password, @db_name)
      rs = con.query("SELECT * FROM " + table_name)
      n_rows = rs.num_rows
    rescue Mysql::Error => e
      self.print_error e
    ensure
      con.close if con
    end
  end
  
  # MISC METHODS
  ############################################################################
  # not used directly but used by other methods in this class.

  # creates a hash map off 2 arrays.
  # basically the read functions from sql return an array.
  # i made a col name function and using those 2 things, i'll create a hash
  # so things are easier to get at.
  #
  # making an assumption that both are the same size and not nil.
  def hash_arrays(col_names, col_result)
    result = Hash.new
    
    # using each syntax. assuming order of the results are aligned with the name.
    col_names.each_with_index do |item, i|
      result[item] = col_result[i]
    end
    
    result
  end

  # returns all hash keys as a space seperated strinng.
  # needed for mysel inserts.
  def hash_get_keys_as_str(some_hash)
    final_str = ""
    first_val = true
    
    some_hash.keys.each do |item|
      # first value does not have an intial space.
      if first_val
        first_val = false
        final_str += item
      else
        # all other items. add a space first.
        final_str += ", " + item
      end
    end
    
    final_str
  end

  # returns all hash keys as a space seperated strinng.
  # needed for mysel inserts.
  # this adds quotes...
  # if you need null values...
  # 
  # probably need to fix this when you see numbers in the hash.
  def hash_get_values_as_str(some_hash)
    final_str = ""
    first_val = true
    
    some_hash.values.each do |item|
      # need to check for strings.
      # and append single quotes.
      #cur_val = item
      #if cur_val.is_a? String
        cur_val = "'" + item.to_s + "'"
      #end
    
      # first value does not have an intial space.
      if first_val
        first_val = false
        final_str += cur_val
      else
        # all other items. add a space first.
        final_str += ", " + cur_val
      end
    end
    
    final_str
  end

  # pass it sql error object and it will print some useful info.
  def print_error(e)
    puts "Error code: #{e.errno}"
    puts "Error message: #{e.error}"
    puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
  end

  # probably dont' need this.
  # this was the inntial test ot see if thing were working.
  # grabbed from some website.
  def server_version
    begin
      con = Mysql.real_connect(@url, @user, @password, @db_name)
      "Server version: " + con.get_server_info
    rescue Mysql::Error => e
      self.print_error e  
    ensure
      con.close if con
    end
  end

end