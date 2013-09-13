require 'rubygems'
require 'mechanize'
require 'csv'

require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/sequel_helper'
require_relative '../util/valid_util'
require_relative '../util/hash_util'

# goes to nasdaq.com and scrapes the website for symbols.
class ScrapeNasdaqSymbols
  
  attr_accessor :web_url, 
                :db_user, 
                :db_password, 
                :db_name, 
                :db_table_name, 
                :user_agent, 
                :agent, 
                :dir_name, 
                :scraper_timeout, 
                :csv_col_def
  
  def initialize(params = {})
    self.init_yaml
    self.init_browser
    self.init_db
    self.init_dir
    self.init_csv
  end
  
  def init_yaml
    @browser_filename = 'config/browser.yml'
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    
    # load the yaml file.
    @browser_prefs = YamlUtil.read(@browser_filename)
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
  end

  def init_browser
    # UA. wikipedia is picky on the UA.
    @user_agent = @browser_prefs['user_agent']
    
    # inital website.
    # using a hash instead of a string.
    @web_url = Hash.new
    @web_url[:nyse] = 'http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NYSE&render=download'
    @web_url[:nasdaq] = 'http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NASDAQ&render=download'
    @web_url[:amex] = 'http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=AMEX&render=download'
    
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
    @db_table_name_stock_symbols = @db_prefs['db_table_name_stock_symbols']
    
    # init db helper
    @db = SequelHelper.new(:url => @db_url, 
                      :user=> @db_user, 
                      :password => @db_password, 
                      :db_name => @db_name)
  end

  def init_dir
    @dir_name = @dir_prefs['stock_symbols']
  end

  # BROKEN
  # need to fix this.
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
  # there are 3 csv files to grab for the nasdaq.
  # if there is move, just move it to 
  def scrape_to_csv
    # cycle through each url
    @web_url.each do |key, value|
      puts key
      
      # grabs daily historial quotes and save it to db.
      result = CsvUtil.fetch_and_save(value, @user_agent, @dir_name, key.to_s) 
    end
    
    return true
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

  # test methods
  ############################################################################
  
  def self.hello
    return true
  end
  
end