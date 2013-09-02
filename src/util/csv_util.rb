require 'rubygems'
require 'mechanize'
require 'csv'

# a few simple helper utils that does some common csv things.
class CsvUtil
  
  # tries to return a string csv.
  # takes an optional user agent.
  # returns nil if it doesn't find anything.
  def self.fetch_csv_from_url(csv_url, user_agent)
    result_csv = nil
    agent = nil
    
    # load a UA. might not need this.
    if user_agent == nil
      agent = Mechanize.new do |a|
        a.user_agent = user_agent
      end
    else
      agent = Mechanize.new
    end
    
    # grabs csv
    agent.get(csv_url) do |page|
      result_csv = page.body
    end
    
    return result_csv
  end
  
  # takes a csv string
  # and a param hash which tells you know to read the csv.
  # and returns an array of hashes using the param_hash as the keys.
  #
  # takes 3 args.
  # csv string - the thing you wanna parse
  # param_hash - basically telling you how to parse things.
  # header_row - a true false result to tell the parser to skip the first row.
  # opt_hash - allows you to add another set of hashes every row.
  #          - probably useful if you need to add primary keys.
  def self.to_array_of_hashes(csv_str, param_hash, header_row, opt_hash)
    # bound checking.
    if csv_str == nil || param_hash == nil
      return nil
    end
    
    # array to return
    result_array = Array.new
    
    # parse each row of the array.
    CSV.parse(csv_str) do |row|
      cur_hash = Hash.new
      
      # iterate thru row.
      param_hash.each do |key, value|
        cur_hash[key.to_sym] = row[value]
      end
      
      # optional hash
      if opt_hash != nil && opt_hash.is_a?(Hash)
        opt_hash.each do |key, value|
          cur_hash[key.to_sym] = value
        end
      end
      
      # store result
      result_array.push(cur_hash)
    end
    
    return result_array
  end
  
  # just a test to see if this was set up correctly on specs.
  def self.hello
    return true
  end
  
end