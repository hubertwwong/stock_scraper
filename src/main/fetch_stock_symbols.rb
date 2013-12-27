require 'sequel_helper'

require_relative '../util/yaml_util'
require_relative '../util/csv_util'
#require_relative '../util/sequel_helper'
require_relative '../util/valid_util'
require_relative '../util/hash_util'

class FetchStockSymbols
  
  attr_accessor :web_url, 
                :user_agent, 
                :agent, 
                :dir_name, 
                :scraper_timeout, 
                :csv_col_def
  
  def initialize(params = {})
    self.init_yaml
    self.init_browser
    self.init_dir
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
  
  def init_dir
    @dir_name = @dir_prefs['stock_symbols']
  end
  
  # just saves things into the csv....
  # there are 3 csv files to grab for the nasdaq.
  # if there is move, just move it to 
  def fetch_all
    # cycle through each url
    @web_url.each do |key, value|
      puts key
      
      # grabs daily historial quotes and save it to db.
      result = CsvUtil.fetch_and_save(value, @user_agent, @dir_name, key.to_s) 
    end
    
    return true
  end
  
end