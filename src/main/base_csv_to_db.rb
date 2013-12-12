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
  def initialize(base_dir = nil, db = nil)
    self.init_yaml
    self.init_db
    self.init_csv
    
    @base_dir = base_dir
    @db = db
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
  def save_to_db(table_name, filename, sql_helper_params)
    @db.table_name = table_name
    @db.filename = filename
    puts "saving to db " + table_name + " " + filename
    @db.load_data(sql_helper_params)
  end  
  
  
  
  # db connections
  ############################################################################
  
  # keep in mind that the you need to fill in db name and file name.
  def connect
    params = {:url => @db_url, :user => @db_user, 
                  :password => @db_password, :db_name => @db_name}
                  #:table_name => "fleet", :filename => "/home/user/fleet.csv"}
    @db = Mysql2Helper.new(params)
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