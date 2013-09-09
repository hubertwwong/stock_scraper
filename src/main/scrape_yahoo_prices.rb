require 'rubygems'
require 'mechanize'
require 'csv'

require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/sequel_helper'
require_relative '../util/valid_util'
require_relative '../util/hash_util'

class ScrapeYahooPrices
  
  attr_accessor :web_url, :db_user, :db_password, :db_name, :db_table_name, :user_agent, :agent, :dir_name, :scraper_timeout, :csv_col_def
  
  def initialize(params = {})
    self.init_yaml
    self.init_browser
    self.init_db
    self.init_dir
    self.init_scraper
    self.init_csv
  end
  
  def init_yaml
    @browser_filename = 'config/browser.yml'
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    @scraper_filename = 'config/yahoo_progress.yml'
    
    # load the yaml file.
    @browser_prefs = YamlUtil.read(@browser_filename)
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
    @scraper_prefs = YamlUtil.read(@scraper_filename)
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

  def init_dir
    @dir_name = @dir_prefs['stock_quotes']
  end

  def init_scraper
    @scraper_timeout = @scraper_prefs['timeout']
  end

  def init_csv
    @csv_col_def = {
      :price_date => 0,
      :open => 1,
      :high => 2,
      :low => 3,
      :close => 4,
      :adj_close => 6,
      :volume => 5
    } 
  end

  # main
  ############################################################################

  def run
    
  end

  # just saves things into the csv....
  # seems to be a bit faster.
  # 
  def scrape_to_csv
    symbol_list = @db.read_all(@db_table_name_stock_symbols)
    cur_sym_count = 0
    num_symbols = symbol_list.length
    
    # cycle thru each symbol.
    symbol_list.each do |cur_sym|
      puts cur_sym[:symbol] + " [" + cur_sym_count.to_s + " / " + num_symbols.to_s + "]"
      
      # grabs daily historial quotes and save it to db.
      result = CsvUtil.fetch_and_save(self.create_url(cur_sym[:symbol]), @user_agent, @dir_name, cur_sym[:symbol])
      
      # sleep so you don't spam site.
      sleep @scraper_timeout
      
      # increment. 
      cur_sym_count = cur_sym_count + 1 
    end
  end

  # steps... loop through files....
  # figure out what the symbol is...
  # figure out what you need to write.
  # trim down csv...
  # write.
  def csv_to_db
    # row hash. basically what each csv column name is and what col it is in.
    pn = Pathname.new(@dir_name)
    pn.each_entry do |file|
      # intial variables.
      cur_date = "1970-01-01" # default date is oldest value possible.
      
      # fetch symbol from filename.
      # using gsub to clean up the .1 and .2 files names.
      cur_sym = file.basename.to_s.gsub(/[.].+$/,"") 
      puts "On " + cur_sym
      
      # need to skip on 2 things. . and ..
      # only continue on symbols.
      unless /[\w]+/.match(cur_sym)
        next
      end
      
      # fetches quotes from the db.
      # basically looking for the most recent quote to figure out what to write.
      params = {:symbol => cur_sym}
      order_param = :price_date
      descending_flag = true
      result_hash = @db.read_where_order(@db_table_name, params, order_param, descending_flag)
      
      # check to see if you enter stuff into the db.
      # returns the most current date.
      if result_hash.size == 0
        puts "no size"
      else
        first_row = result_hash.first
        cur_date = first_row[:price_date]
        puts cur_date
      end
      
      # fetch stuff from CSV.
      # limit the fetching by date.
      opt_hash = {
        :col => :price_date,
        :value => cur_date,
        :op => ">"
      }
      has_header = true
      #puts ">>>>> " + cur_sym
      #puts ">>>>" + pn.to_s
      result = CsvUtil.read_csv_as_hash(pn.to_s, cur_sym, csv_col_def, opt_hash, has_header)
      
      # inject the current symbol into the results.
      # so the db rows are complete so you can write the results to it.
      const_hash = {
        :symbol => cur_sym
      }
      injected_results = HashUtil.add_constant_to_array_hash(result, const_hash)
      
      # saves result to db...
      self.save_to_db(injected_results)
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
    
    opt_hash = {
      :symbol => symbol
    }
    
    # fetch csv.
    result_csv = CsvUtil.fetch_csv_from_url(final_url, @user_agent)
    
    # load hash object to save.
    array_of_hashes = CsvUtil.to_array_of_hashes(result_csv, @csv_col_def, true, opt_hash)
  
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
  
end