require 'rubygems'
require 'mechanize'

require_relative '../util/sql_util'
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
    @db = SqlUtil.new(:url => @db_url, 
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
    self.save_array_to_db(result)
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
            cur_hash['symbol'] = row.search('td[1]').text
            cur_hash['company_name'] = row.search('td[2]').text
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
  
  # calls a save to db a ton of times.
  # assumes an array. and assumes the hash contains
  # the column rows => column values
  def save_array_to_db(array_of_hashes)
    if array_of_hashes == nil
      return nil
    else
      array_of_hashes.each do |row|
        # if things are not nil.
        if row != nil && row['symbol'] != nil
          # check if symbol is stored in db..
          # if it is, you probably don't want to update it.
          row_from_db = @db.read_with_one_param(@db_table_name, 'symbol', row['symbol'])
          
          # if you don't find a row, you don't have the symbol in the db.
          # store it.
          if row_from_db == nil
            #puts '> writing [' + row['symbol'] + '][' + SqlUtil.escape_str(row['company_name']) + ']'
            db_row = row
            db_row['company_name'] = SqlUtil.escape_str(db_row['company_name'])
            self.save_to_db(db_row)
          end
        end
      end
      
      # probably did some writing. return true
      return true
    end
  end
  
  # saves a valid result to db.
  # assumes you used the hashing method in the funciton.
  def save_to_db(result_hash)
    puts "saving..."
    puts result_hash.inspect
    
    @db.replace_one(@db_table_name, result_hash)
  end
  
  # test
  ############################################################################
  def hello
    true
  end
  
end