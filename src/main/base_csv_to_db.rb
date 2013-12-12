require 'rubygems'

require 'mysql2_helper'

require_relative '../util/yaml_util'

# a base class to save csv's to the db.
# class pulls 
class BaseCsvToDb
  
  attr_accessor :base_dir, :db
  
  # init the class.
  # can take two params in addition to the yaml files.
  # 1. base_dir: if you have a lot of files, you can specify a directory
  #    that the files are in so you don't have to enter it every time.
  # 2. db: the mysql2 object. if you have an connection, you can just pass it the db object.  
  def initialize(params = {})
    params = {
              base_dir: nil,
              db: nil
             }.merge(params)
    @base_dir = params.fetch(:base_dir)
    @db = params.fetch(:db)
    
    self.init_yaml
    self.init_db
  end
  
  def init_yaml
    @db_filename = 'config/database.yml'
    
    # load the yaml file.
    @db_prefs = YamlUtil.read(@db_filename)
  end
  
  def init_db
    # load db params from yaml file.
    @db_user = @db_prefs['db_user']
    @db_password = @db_prefs['db_password']
    @db_url = @db_prefs['db_url']
    @db_name = @db_prefs['db_name']
    
    # connect to the db.
    self.connect
  end


  


  # main
  ############################################################################
  
  # saves to the db.
  def save_to_db(params = {})
    table_name = params.fetch(:table_name)
    filename = params.fetch(:filename)
    sql_params = params.fetch(:sql_params)
    
    # add the base dir if its not nil.
    if @base_dir != nil
      @db.filename = @base_dir + filename
    else
      @db.filename = filename
    end
    
    puts "db name >>>> " + @db.db_name
      
    @db.table_name = table_name
    puts "saving to db " + table_name + " " + filename
    result = @db.load_data(sql_params)
    
    return result
  end  
  
  
  
  # db connections
  ############################################################################
  
  # keep in mind that the you need to fill in db name and file name.
  def connect(params = {})
    params = {
              url: nil,
              user: nil,
              password: nil,
              db_name: nil
             }.merge(params)
    
    # if params are specified, override the instance variables.
    @db_url = params.fetch(:url) || @db_url
    @db_user = params.fetch(:user)  || @db_user
    @db_password = params.fetch(:password) || @db_password
    @db_name = params.fetch(:db_name) || @db_name
    
    # load params in the hash.
    final_params = {:url => @db_url, :user => @db_user, 
                  :password => @db_password, :db_name => @db_name}
    
    @db = Mysql2Helper.new(final_params)
  end
  
  
  
  # test
  ############################################################################
  
  def hello
    return "hello"
  end
  
  #@db_params = {:concurrent_flag => true,
  #            :replace_flag => true,
  #            :fields_term_by => "\t",
  #            :line_term_by => "\r\n",
  #            :skip_num_lines => 1,
  #            :col_names => ["@dummy", "name", "description"],
  #            :set_col_names => ["name='zzzz'"]}
  #result = @db.load_data(@db_params)
  
end