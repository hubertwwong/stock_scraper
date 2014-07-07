require_relative '../util/yaml_util'

class ScrapeWikiSP500
  
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
    @web_url = 'http://en.m.wikipedia.org/wiki/List_of_S%26P_500_companies'
    
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
    @db_table_name = @db_prefs['db_table_name_stock_symbols']
    
    # init db helper
    #@db = SqlUtil.new(:url => @db_url, 
    #                  :user=> @db_user, 
    #                  :password => @db_password, 
    #                  :db_name => @db_name)
    @db = SequelHelper.new(:url => @db_url, 
                      :user=> @db_user, 
                      :password => @db_password, 
                      :db_name => @db_name)
  end

  # main
  ############################################################################
  
  # runs the parser and saves the stuff to the db.
  def run
    result = self.visit_and_parse
    #puts result.inspect
    #self.save_array_to_db(result)
    self.save_to_db(result)
  end
  
  # goes to wikipedia
  # grabs the company name and symbol of the s&p500
  def visit_and_parse
    begin
      #stash results.
      result = Array.new
      
      @agent.get(@web_url) do |page|
        #puts page.title
        #pp page
        page.search('//table//tr').each do |row|
          cur_hash = Hash.new
          cur_sym = row.search('td[1]').text
          
          #puts cur_sym
          if self.stock_symbol?(cur_sym)
            cur_hash[:symbol] = row.search('td[1]').text
            cur_hash[:company_name] = row.search('td[2]').text
            result.push(cur_hash)
          end
          #puts 'dies here...'
        end
        
        puts ">>> end"
        return result
        #return true
      end
    rescue
      # 404 error
      puts '404 error'
      return nil
    end
  end
  
  # helper
  ############################################################################
  
  # check if a string is a stock symbol.
  # symbols needs 1-4 charcters. upper case.
  def stock_symbol?(possibe_str)
    pop = /^[A-Z]{1,4}$/.match(possibe_str)
    if pop == nil
      #puts 'no match'
      return false
    else
      #puts 'match'
      return true
    end
  end
  
  def save_to_db(array_of_hashes)
    puts '>>> saving'
    @db.multiple_unique(@db_table_name, array_of_hashes)
  end
  
  # test
  ############################################################################
  def hello
    true
  end
  
end