require 'sequel_helper'

require_relative '../util/yaml_util'
require_relative '../util/csv_util'
#require_relative '../util/sequel_helper'
require_relative '../util/valid_util'
require_relative '../util/hash_util'

class SaveYahooQuotes

  attr_accessor :db_user, :db_password, :db_name, :db_table_name, :dir_name
  
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
    #@db_user = @db_prefs['db_user']
    #@db_password = @db_prefs['db_password']
    #@db_url = @db_prefs['db_url']
    @db_name = @db_prefs['db_name']
    @db_table_name_stock_quotes = @db_prefs['db_table_name_stock_quotes']
    @db_table_name_stock_symbols = @db_prefs['db_table_name_stock_symbols']
  end

  def init_dir
    @dir_name = @dir_prefs['stock_quotes']
  end

  def init_csv
    # main helper function.
    puts @dir_name + "<<<<<"
    @csv_to_db = BaseCsvToDb.new(:base_dir => @dir_name)
    
    # CSV params needed by the MYSQL load data command
    @csv_params = {
              :ignore_flag => true,
              :fields_term_by => ",",
              :line_term_by => "\n",
              :skip_num_lines => 1,
              :col_names => ["price_date", "open", "high", "low", "close", "volume", "adj_close"]}
  end



  # main
  ############################################################################

  # goes to the directory that contains all of the csv files.
  # calls each one and saves to the db.
  def save_all_csv_to_db
    cur_sym_count = 0
    
    # row hash. basically what each csv column name is and what col it is in.
    pn = Pathname.new(@dir_name)
    pn.each_entry do |file|
      # fetch symbol from filename.
      # using gsub to clean up the .1 and .2 files names.
      cur_sym = file.basename.to_s.gsub(/[.].+$/,"") 
      puts "On " + cur_sym
      
      # need to skip on 2 things. . and ..
      # only continue on symbols.
      unless /[\w]+/.match(cur_sym)
        next
      end
      
      puts ">>> on sym " + cur_sym_count.to_s
      cur_sym_count = cur_sym_count + 1
      
      # saves result to db...
      self.save_to_db(cur_sym, file.basename.to_s)
    end
  end
  
  # saves the file the db.
  # format should be the same.
  def save_to_db(symbol, filename)
    # set_col allows you to override the csv import
    # in this case, we want to write the symbol out in the symbol column.
    @csv_params[:set_col_names] = ["symbol='"+ symbol + "'"]
    
    save_params = {:table_name => @db_table_name_stock_quotes,
              :filename => filename,
              :sql_params => @csv_params}
    # saves to the db and returns if it was successful
    return @csv_to_db.save_to_db(save_params)
  end

end