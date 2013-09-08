require 'rubygems'
require 'mechanize'
require 'csv'

#require_relative '../util/sql_util'
require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/sequel_helper'

class ScrapeYahooPrices
  
  attr_accessor :web_url, :db_user, :db_password, :db_name, :db_table_name, :user_agent, :agent
  
  def initialize(params = {})
    self.init_yaml
    self.init_browser
    self.init_db
  end
  
  def init_yaml
    @browser_filename = 'config/browser.yml'
    @db_filename = 'config/database.yml'
    
    # load the yaml file.
    @browser_prefs = YamlUtil.read(@browser_filename)
    @db_prefs = YamlUtil.read(@db_filename)
  end

  def init_browser
    # UA. wikipedia is picky on the UA.
    @user_agent = @browser_prefs['user_agent']
    
    # inital website.
    @web_url = 'http://ichart.finance.yahoo.com/table.csv?s=ZZZZ&d=7&e=27&f=2015&g=d&a=3&b=12&c=1900&ignore=.csv'
    
    # load a UA. might not need this.
    @agent = Mechanize.new do |a|
      a.user_agent = @user_agent
    end
  end

  def init_db
    # yaml read test....
    @db_user = @db_prefs['db_user']
    @db_password = @db_prefs['db_password']
    @db_url = @db_prefs['db_url']
    @db_name = @db_prefs['db_name']
    @db_table_name = @db_prefs['db_table_name_stock_quotes']
    @db_table_name_stock_symbols = @db_prefs['db_table_name_stock_symbols']
    
    # init db helper
    @db = SequelHelper.new(:url => @db_url, 
                      :user=> @db_user, 
                      :password => @db_password, 
                      :db_name => @db_name)
  end

  # main
  ############################################################################

  def run
    
  end

  # just saves things into the csv....
  # seems to be a bit faster.
  # 
  def run_sp500_to_csv
    symbol_list = @db.read_all(@db_table_name_stock_symbols)
    cur_sym_count = 0
    sleep_timeout = 10
    num_symbols = symbol_list.length
    
    # cycle thru each symbol.
    symbol_list.each do |cur_sym|
      puts cur_sym[:symbol] + " [" + cur_sym_count.to_s + " / " + num_symbols.to_s + "]"
      
      # grabs daily historial quotes and save it to db.
      result = self.visit_and_get_csv(cur_sym[:symbol])
      
      # sleep so you don't spam site.
      sleep sleep_timeout
      
      # increment. 
      cur_sym_count = cur_sym_count + 1 
    end
  end

  # pulls down stock from the quotes.
  # only have s&p 500 for now..
  # and gets the symbols. goes to yahoo and fetches the csv.
  # puts that into the db.
  def run_sp500
    symbol_list = @db.read_all(@db_table_name_stock_symbols)
    cur_sym_count = 0
    sleep_timeout = 10
    num_symbols = symbol_list.length
    
    # cycle thru each symbol.
    symbol_list.each do |cur_sym|
      puts cur_sym[:symbol] + " [" + cur_sym_count.to_s + " / " + num_symbols.to_s + "]"
      
      # grabs daily historial quotes and save it to db.
      result = self.visit_and_get_csv(cur_sym[:symbol])
      self.save_to_db(result)
      
      # sleep so you don't spam site.
      sleep sleep_timeout
      
      # increment. 
      cur_sym_count = cur_sym_count + 1 
    end
  end

  # an updated version...
  #
  # vist_and_get_csv
  #
  # column order.
  # Date, Open, High, Low, Close, Volume, Adj Close
  #
  def visit_and_get_csv(symbol)
    final_url = self.create_url(symbol)
    result_csv = ""
    first_row = true
    
    # row hash. basically what each csv column name is and what col it is in.
    col_def = {
      :price_date => 0,
      :open => 1,
      :high => 2,
      :low => 3,
      :close => 4,
      :adj_close => 6,
      :volume => 5
    }
    
    opt_hash = {
      :symbol => symbol
    }
    
    # fetch csv.
    result_csv = CsvUtil.fetch_csv_from_url(final_url, @user_agent)
    
    # load hash object to save.
    array_of_hashes = CsvUtil.to_array_of_hashes(result_csv, col_def, true, opt_hash)
  
    return array_of_hashes  
  end

  # helper methods
  ############################################################################

  # saves a valid result to db.
  # assumes you used the hashing method in the funciton.
  def save_to_db(array_result_hash)
    puts "saving..."
    @db.multiple_unique(@db_table_name, array_result_hash)
  end

  # dumb method... just replace the ZZZZ with the symbol
  # might want to change it so it does something else.
  # or to redo the dates.
  def create_url(symbol)
    @web_url.gsub('ZZZZ', symbol)
  end

  # test
  ############################################################################
  def hello
    true
  end
  
end