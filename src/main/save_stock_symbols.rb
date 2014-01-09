require 'sequel_helper'

require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/valid_util'
require_relative '../util/hash_util'

class SaveStockSymbols
  
  attr_accessor :db_user, 
                :db_password, 
                :db_name, 
                :db_table_name, 
                :dir_name, 
                :csv_col_def
  
  def initialize(params = {})
    self.init_yaml
    self.init_db
    self.init_dir
    self.init_csv
  end
  
  def init_yaml
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    
    # load the yaml file.
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
  end

  def init_db
    @db_name = @db_prefs['db_name']
    @db_table_name_stock_quotes = @db_prefs['db_table_name_stock_quotes']
    @db_table_name_stock_symbols = @db_prefs['db_table_name_stock_symbols']
    @sequel_helper = SequelHelperFactory.create
  end

  def init_dir
    @dir_name = @dir_prefs['stock_symbols']
  end
  
  def init_csv
    # CSV cols.
    @col_names = ["symbol", "company_name", "@dummy", "@dummy", "@dummy", 
                  "@dummy", "sector", "industry", "@dummy"]
    
    @table_cols = ["symbol", "company_name", "sector", "industry"]
    
    @key_cols = ["symbol"]
    
    # fix skip line numbers.                  
    @csv_params = {:filename => nil,
                   :line_term_by => "\n",
                   :fields_term_by => ",",
                   :fields_enclosed_by => "\"",
                   :skip_num_lines => 1,
                   :local_flag => true,
                   :col_names => @col_names,
                   :set_col_names => nil}
                         
    @import_csv_params = {:csv_params => @csv_params,
                          :table_name => @db_table_name_stock_symbols,
                          :table_cols => @table_cols,
                          :key_cols => @key_cols}
  end
  
  # things to fix..
  # need to take files...
  # 
  def save_to_db#(filename)
    puts ">> save to db "
    
    # adding file name to the params.
    #@csv_params[:filename] = "@base_dir + filename"
    @csv_params[:filename] = "/home/user/.stock_scraper/csv/stock_symbols/nyse.csv"
    #@csv_params[:set_col_names] = ["symbol='AAPL'"]
    
    @import_csv_params[:csv_params] = @csv_params
    
    puts "DEBUGGING" + @import_csv_params.to_s
    
    @sequel_helper.import_csv @import_csv_params
    
    return false
  end
  
end