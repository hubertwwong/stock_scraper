require 'net/ftp'
require 'nokogiri'
require 'open-uri'

require_relative '../util/yaml_util'
require_relative '../util/file_wrapper_util'

class ParseXBRLKeys

def initialize(params = {})
    self.init_yaml
    self.init_dir
  end
  
  def init_yaml
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    
    # load the yaml file.
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
  end

  def init_dir
    @dir_name = @dir_prefs['xbrl_keys']
    puts @dir_name
  end  
  
  # main
  ############################################################################

  # get the zip files names in the xbrl key names.
  # either returns nil or an array of xbrl file locations.
  # I stripped out the prefix "http://www.sec.gov/Archives"
  # you can add it back in if you are fetching from the website.
  # if you are fetching from the sec ftp site.
  # you can just use this directly.
  def get_zip_file_names(xbrl_str)
    # quick sanity check.
    if xbrl_str == nil || xbrl_str == ""
      return nil
    end
    
    # using nokogiri to parse the xml
    doc = Nokogiri::XML(xbrl_str)
    array_file_names = Array.new
    # result array.
    
    # go to the guid element.
    doc.xpath("//guid").each do |item|
      # strip out this prefix.
      prefix = "http://www.sec.gov/Archives"
      final_str = item.content.gsub(prefix, "")
      
      # add item to array to return..
      array_file_names.push(final_str)
      #puts final_str
    end
    
    return array_file_names
  end
  
end