require 'rubygems'
require 'mechanize'
require 'csv'

require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/sequel_helper'
require_relative '../util/valid_util'
require_relative '../util/hash_util'

# splitting the csv feting from the csv import.
# this class will just be for the fetching.
class FetchYahooQuotes
  
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






  # helper methods
  ############################################################################
  
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