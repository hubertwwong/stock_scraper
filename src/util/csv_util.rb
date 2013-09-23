require 'rubygems'
require 'mechanize'
require 'csv'
require 'pathname'

# a few simple helper utils that does some common csv things.
class CsvUtil

  # reads a file name and returns a string or nil...
  #
  # also takea an option hash so you can limit the amout of stuff you import.
  # assumes that the data is sorted in either ascending or descending order.
  # a or d for the option.
  # see below for an example.
  #
  # opt_hash = {
  #   :col => :price_date,
  #   :value => "2013-01-01"
  #   :op => ">"
  # }
  #
  # opt hash provides a positive filter. anything that passes the filters
  # is saved to the list.
  #
  # keep it simple....
  # basically opt has is just going to set a cut off point base off a value
  # not going to do any re ordering for now...
  # also keep in mind that the checker is dumb...
  #
  def self.read_csv_as_hash(dir_name, file_name, param_hash, opt_hash, remove_header)
    result_csv = Array.new
    first_row_flag = remove_header
    
    # paths. using clean path to sanitize input.
    pn = Pathname.new(dir_name)
    cleaned_path = pn.join(file_name + '.csv').to_s
    
    CSV.foreach(cleaned_path) do |row|
      if first_row_flag
        first_row_flag = false
      else
        cur_hash = Hash.new
        
        # load hash....
        param_hash.each do |key, value|
          cur_hash[key] = row[value]
        end
        
        # check if we need to push into the list.
        # need to figure out the order first.
        if opt_hash != nil
          cur_val = cur_hash[opt_hash[:col]]
          checked_val = opt_hash[:value]
          cur_op = opt_hash[:op]
          #puts opt_hash
          #puts ">>>" + opt_hash[:col].to_s
          #puts ">>" + cur_hash[opt_hash[:col]]
          #puts ">" + opt_hash[:value]
          
          # adding a check for date. need to convert it to ints.
          if checked_val.is_a? (Date)
            checked_val = checked_val.to_time.to_i
            
            #puts ">>" + cur_val.to_s
            cur_val = Date.parse(cur_val).to_time.to_i
            #puts cur_val.to_s + "<<"
          end
          
          if cur_op == ">" && (cur_val > checked_val)
            result_csv << cur_hash
          elsif cur_op == ">=" && (cur_val >= checked_val)
            result_csv << cur_hash
          elsif cur_op == "<" && (cur_val < checked_val)
            result_csv << cur_hash
          elsif cur_op == "<=" && (cur_val <= checked_val)
            result_csv << cur_hash
          elsif cur_op == "==" && (cur_val == checked_val)
            result_csv << cur_hash
          else
            #puts "skip " + cur_val.to_s 
          end 
        else
          result_csv << cur_hash
        end
      end
    end
    
    return result_csv
  end

  # fetch and saves url to a directory
  # file name adds the csv.... so you don't have to...
  def self.fetch_and_save(csv_url, user_agent, dir_name, file_name)
    agent = nil
    
    # load a UA. might not need this.
    if user_agent == nil
      agent = Mechanize.new do |a|
        a.user_agent = user_agent
      end
    else
      agent = Mechanize.new
    end
    
    # paths. using clean path to sanitize input.
    pn = Pathname.new(dir_name)
    cleaned_path = pn.join(file_name + '.csv').to_s
    #puts cleaned_path
    
    begin
      agent.pluggable_parser.default = Mechanize::Download
      agent.get(csv_url).save!(cleaned_path)
      puts "saved... " + cleaned_path
      return true
    rescue
      puts "error..."
      return false
    end
  end
  
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