require_relative '../util/sequel_helper_factory'
require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/valid_util'
require_relative '../util/hash_util'

# splitting the csv feting from the csv import.
# this class will just be for the fetching.
class FetchYahooQuotes
  
  attr_accessor :web_url, :user_agent, :agent, :dir_name, :scraper_timeout, :csv_col_def
  
  def initialize(params = {})
    self.init_yaml
    self.init_browser
    self.init_db
    self.init_dir
    self.init_scraper
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
    @db_table_name = @db_prefs['db_table_name_stock_quotes']
    @db_table_name_stock_symbols = @db_prefs['db_table_name_stock_symbols']
    
    # init db helper
    @db = SequelHelperFactory.create
  end
  
  def init_dir
    @dir_name = @dir_prefs['stock_quotes']
  end

  def init_scraper
    @scraper_timeout = @scraper_prefs['timeout']
  end
  
  
  
  # main
  ############################################################################

  # fetch csvs from yahoo site and saves to the disk.
  #
  def fetch_csvs_to_file
    #symbol_list = @db.read_all(@db_table_name_stock_symbols)
    symbol_list = @db.client[@db_table_name_stock_symbols]
    puts ">>>>>> [" + symbol_list.all.to_s + "]"
    cur_sym_count = 0
    num_symbols = symbol_list.length
    
    
    # cycle thru each symbol.
    symbol_list.each do |cur_sym|
      puts cur_sym[:symbol] + " [" + cur_sym_count.to_s + 
                              " / " + num_symbols.to_s + "]"
      
      # grabs daily historial quotes and save it to db.
      result = CsvUtil.fetch_and_save(self.create_url(cur_sym[:symbol]), 
                              @user_agent, @dir_name, cur_sym[:symbol])
      
      # error happened...
      if result == false
        return false
      end
      
      # sleep so you don't spam site.
      sleep @scraper_timeout
      
      # increment.
      cur_sym_count = cur_sym_count + 1 
    end
    
    puts ">>>>>> fetch_csvs_to_file_end"
    
    return true
  end



  # helper methods
  ############################################################################
  
  # create_url
  # 
  # generates a url given a symbol.
  # basically replaces ZZZZ with its actual symbol.
  # todo: add a data param.
  def create_url(symbol)
    @web_url.gsub('ZZZZ', symbol)
  end  
  
  
  
  # test
  ############################################################################
  def hello
    true
  end
  
end