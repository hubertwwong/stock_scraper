require_relative '../util/sequel_helper_factory'
require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/valid_util'
require_relative '../util/hash_util'
require_relative '../util/str_util'
require_relative 'yaml_config_loader'

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
    @ycl = YAMLConfigLoader.new
      
    # load the yaml file.
    @browser_prefs = @ycl.browser_prefs
    @db_prefs = @ycl.db_prefs
    @dir_prefs = @ycl.dir_prefs
    @scraper_prefs = @ycl.scraper_prefs  
  end

  def init_browser
    # UA. wikipedia is picky on the UA.
    @user_agent = @browser_prefs['user_agent']
    
    # inital website.
    @web_url = 'http://ichart.finance.yahoo.com/table.csv?s=ZZZZ&d=ZZDD&e=ZZEE&f=ZZFF&g=d&a=ZZAA&b=ZZBB&c=ZZCC&ignore=.csv'
    
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
  # takes an optional param of start date.
  # so you don't download a gig of data after each update.
  #
  def fetch_all(start_date = nil)
    #symbol_list = @db.read_all(@db_table_name_stock_symbols)
    symbol_list = @db.client[@db_table_name_stock_symbols.to_sym].all
    cur_sym_count = 0
    num_symbols = symbol_list.length
    
    # cycle thru each symbol.
    symbol_list.each do |cur_sym|
      puts cur_sym
      puts cur_sym[:symbol] + " [" + cur_sym_count.to_s + 
                              " / " + num_symbols.to_s + "]"
      
      # grabs daily historial quotes and save it to db.
      sym_url = self.create_url(cur_sym[:symbol], 
                                cur_sym[:sub_symbol_1], 
                                cur_sym[:sub_symbol_2],
                                start_date)
      result = CsvUtil.fetch_and_save(sym_url,
                                      @user_agent, 
                                      @dir_name, 
                                      cur_sym[:id].to_s)
      
      # error happened...
      # try 2 more times...
      retry_timeout = 1
      while result == false && retry_timeout < 3
        puts "fetch error. retry in " + retry_timeout.to_s
        sleep @scraper_timeout * retry_timeout
        
        result = CsvUtil.fetch_and_save(sym_url,
                                      @user_agent, 
                                      @dir_name, 
                                      cur_sym[:id].to_s,
                                      start_date)
        # increase the timeout..         
        retry_timeout += 1
      end
      
      # sleep so you don't spam site.
      sleep @scraper_timeout
      
      # increment.
      cur_sym_count = cur_sym_count + 1 
    end
    
    puts ">> fetch yahoo quotes complete"
    
    return true
  end



  # helper methods
  ############################################################################
  
  # create_url
  # 
  # generates a url given a symbol.
  # basically replaces ZZZZ with its actual symbol.
  # todo: add a data param.
  # start and end date........ YYYY-MM-DD
  #
  # url date format... note that a=month b=day c=year. 
  # and a is 0 based
  def create_url(symbol, sub_symbol_1, sub_symbol_2, start_date=nil)
    sym_str = symbol
    final_url = @web_url
    
    # symbols
    if sub_symbol_2 != nil && sub_symbol_2 != ""
      sym_str = symbol + "-" + sub_symbol_1 + "-" + sub_symbol_2
    elsif sub_symbol_1 != nil && sub_symbol_1 != ""
      sym_str = symbol + "-" + sub_symbol_1
    else
      sym_str = symbol
    end
    final_url = final_url.gsub('ZZZZ', sym_str)
    
    # DEFAULT DATES
    final_url = final_url.gsub('ZZDD', "0")
    final_url = final_url.gsub('ZZEE', "1")
    final_url = final_url.gsub('ZZFF', "2020")
    if (start_date == nil)
      final_url = final_url.gsub('ZZAA', "0")
      final_url = final_url.gsub('ZZBB', "1")
      final_url = final_url.gsub('ZZCC', "1900")
    else
      array_date = StrUtil.str_to_array(start_date)
      
      # month is zero based in yahoo for some reason.
      final_url = final_url.gsub('ZZAA', (array_date[1].to_i - 1).to_s)
      final_url = final_url.gsub('ZZBB', array_date[2])
      final_url = final_url.gsub('ZZCC', array_date[0])
    end
    
    return final_url
  end  
  
  # a simple helper that returns the date 1 month ago
  # in yyyy-mm-dd format. can be used for the start date
  # varaible in create url.
  def one_month_ago
    #puts "aaaaaaaaaaaaaaaa"
    #puts Time.now.strftime("%Y-%m-%d")
    #puts "zzzzzzzzzzzzzzzzzzzz"
    #one_month_ago = Time.now.to_i - 60*60*24*30
    #puts "time ago to s " + Time.now.to_i.to_s
    #puts "one month ago " + one_month_ago.to_s
    #puts Time.at(one_month_ago).strftime("%Y-%m-%d")
    #puts "bbbbb"
    
    one_month_ago = Time.now.to_i - 60*60*24*30
    return Time.at(one_month_ago).strftime("%Y-%m-%d")
  end
  
  # test
  ############################################################################
  def hello
    true
  end
  
end