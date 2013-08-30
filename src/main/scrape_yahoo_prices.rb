require 'rubygems'
require 'mechanize'
require 'csv'

require_relative '../util/sql_util'
require_relative '../util/yaml_util'

class ScrapeYahooPrices
  
  attr_accessor :web_url, :db_user, :db_password, :db_name, :db_table_name, :web_url, :user_agent, :agent
  
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
    
    # init db helper
    @db = SqlUtil.new(:url => @db_url, 
                      :user=> @db_user, 
                      :password => @db_password, 
                      :db_name => @db_name)
  end

  # main
  ############################################################################

  def run
    
  end

  def visit_and_get_csv(symbol)
    puts 'visit_and_get_csv'
    final_url = self.create_url(symbol)
    result_csv = ""
    
    @agent.get(final_url) do |page|
      result_csv = page.body
    end
    
    return result_csv
  end

  # seems like the string row is really an item
  #
  # column order.
  # Date, Open, High, Low, Close, Volume, Adj Close
  # 
  def save_csv_to_db(csv_string, symbol)
    puts 'save_csv_to_db'
    puts csv_string.length.to_s
    first_row = true
    
    # note that row is an array.
    CSV.parse(csv_string) do |row|
      # puts 'zzz'
      cur_quote = Hash.new
      
      # skip first row which contains the label.
      if first_row == false
        puts row
        # load hash object to save.
        cur_quote['price_date'] = row[0]
        cur_quote['open'] = row[1]
        cur_quote['high'] = row[2]
        cur_quote['low'] = row[3]
        cur_quote['close'] = row[4]
        cur_quote['adj_close'] = row[6]
        cur_quote['volume'] = row[5]
        cur_quote['symbol'] = symbol
        #puts row[0].to_s
        #puts row[1].to_s
        #puts row[2].to_s
        #puts row[3].to_s
        #puts row[4].to_s
        #puts row[5].to_s
        #puts row[6].to_s
        
        # save to db.
        puts 'saving.'
        self.save_to_db(cur_quote)
      else
        puts row
        first_row = false
      end
    end
    
    return true
  end

  # saves a valid result to db.
  # assumes you used the hashing method in the funciton.
  def save_to_db(result_hash)
    puts "saving..."
    puts result_hash.inspect
    
    @db.replace_one(@db_table_name, result_hash)
  end

  # helper
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