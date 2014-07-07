require 'sequel_helper'

require_relative '../util/sequel_helper_factory'
require_relative '../util/yaml_util'
require_relative '../util/csv_util'
#require_relative '../util/sequel_helper'
require_relative '../util/valid_util'
require_relative '../util/hash_util'
require_relative '../util/file_wrapper_util'
require_relative 'yaml_config_loader'

class SaveYahooQuotes

  attr_accessor :db_user, :db_password, :db_name, :db_table_name, :dir_name
  
  def initialize
    self.init_yaml
    self.init_dir
    self.init_db
    self.init_csv
  end
  
  def init_yaml
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    @ycl = YAMLConfigLoader.new
      
    # load the yaml file.
    #@db_prefs = YamlUtil.read(@db_filename)
    #@dir_prefs = YamlUtil.read(@dir_filename)
    @db_prefs = @ycl.db_prefs
    @dir_prefs = @ycl.dir_prefs
  end

  def init_db
    @db_name = @db_prefs['db_name']
    @db_table_name_stock_quotes = @db_prefs['db_table_name_stock_quotes']
    @db_table_name_stock_symbols = @db_prefs['db_table_name_stock_symbols']
    @sequel_helper = SequelHelperFactory.create
  end

  def init_dir
    @dir_name = @dir_prefs['stock_quotes']
  end

  def init_csv
    @csv_col_names = ["price_date", "open", "high", "low", "close", "volume", 
                  "adj_close"]
    
    @db_table_cols = ["price_date", "open", "high", "low", "close", "volume", 
                   "adj_close", "stock_symbol_id"]
    
    @key_cols = ["price_date", "stock_symbol_id"]
    
    # fix skip line numbers.                  
    @csv_params = {:filename => nil,
                   :line_term_by => "\n",
                   :fields_term_by => ",",
                   :skip_num_lines => 1,
                   :local_flag => true,
                   :col_names => @csv_col_names,
                   :set_col_names => nil}
                         
    @import_csv_params = {:csv_params => @csv_params,
                          :table_name => @db_table_name_stock_quotes,
                          :table_cols => @db_table_cols,
                          :key_cols => @key_cols}
    
    #result = @db.import_csv @params
  end



  # main
  ############################################################################

  # goes to the directory that contains all of the csv files.
  # calls each one and saves to the db.
  def save_all_to_db
    cur_sym_count = 0
    
    # row hash. basically what each csv column name is and what col it is in.
    pn = Pathname.new(@dir_name)
    pn.each_entry do |file|
      # fetch symbol from filename.
      # using gsub to clean up the .1 and .2 files names.
      cur_sym = file.basename.to_s.gsub(/[.].+$/,"") 
      puts "On " + cur_sym.to_s
      
      # need to skip on 2 things. . and ..
      # only continue on symbols.
      unless /[\w]+/.match(cur_sym)
        next
      end
      
      puts ">>> on sym " + cur_sym_count.to_s
      cur_sym_count = cur_sym_count + 1
      
      # saves result to db...
      self.save_to_db(cur_sym, file.basename.to_s, @dir_name.to_s)
    end
  end
  
  # saves the file the db.
  # format should be the same.
  def save_to_db(symbol_id, filename, base_dir)
    puts ">> save to db " + symbol_id.to_s + " " + filename.to_s
    
    # adding file name to the params.
    #@csv_params[:filename] = "@base_dir + filename"
    #@csv_params[:filename] = "/home/user/.stock_scraper/csv/stock_quotes/AAPL.csv"
    #@csv_params[:set_col_names] = ["symbol='AAPL'"]
    #@csv_params[:filename] = base_dir + filename
    @csv_params[:filename] = "/tmp/" + filename
    @csv_params[:set_col_names] = ["stock_symbol_id='" + symbol_id.to_s + "'"]
    
    @import_csv_params[:csv_params] = @csv_params
    
    # debugging params.
    puts "DEBUGGING" + @import_csv_params.to_s
    
    # importing file
    @sequel_helper.import_csv @import_csv_params
    
    # cleanup
    dest_dir = base_dir + "completed/" + filename.to_s
    FileWrapperUtil.mv(@csv_params[:filename], dest_dir)
    
    return false
    #return @csv_to_db.save_to_db(save_params)
  end

end