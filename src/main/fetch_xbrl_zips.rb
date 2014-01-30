require 'net/ftp'
require 'pathname'

require_relative '../util/yaml_util'
require_relative '../util/file_wrapper_util'
require_relative '../util/ftp_helper'
require_relative 'parse_xbrl_keys'

# fetching the actual xbrl files.
# uses the key files to find the locations of the zips
# compiles a list of said zips.
# and downloading it.
class FetchXBRLZips
  
  def initialize(params = {})
    self.init_yaml
    self.init_dir
    self.init_sec
  end
  
  def init_yaml
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    @sec_filename = 'config/sec_urls.yml'
    
    # load the yaml file.
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
    @sec_prefs = YamlUtil.read(@sec_filename)
  end

  def init_dir
    @edgar_dir_name = @dir_prefs['sec_edgar_ftp']
    @xbrl_keys_dir_name = @dir_prefs['sec_edgar_ftp_xbrl_keys']
    #puts @dir_name
  end  
  
  def init_sec
    @sec_base_url = @sec_prefs['base_url']
    @sec_xbrl_keys_dir = @sec_prefs['xbrl_keys_dir']
    #puts @sec_base_url
    #puts @sec_xbrl_keys_dir
  end
  
  # main
  ############################################################################
  
  def fetch_all_zips
    #puts ">>SEC>>>"
    #puts @sec_xbrl_keys_dir
    #puts @dir_name
    #puts ">>SEC>>>"
    
    # get all keys.
    array_of_xbrl_paths = self.fetch_all_keys
    
    f = FTPHelper.new(:url => @sec_base_url)
    f.connect
    f.download_all(array_of_xbrl_paths, @edgar_dir_name, 10)
    f.disconnect
      
    return true
  end
  
  def fetch_all_keys
    array_of_zips_path = Array.new
    pn = Pathname.new(@xbrl_keys_dir_name)
    index = 0
    
    # iterate on files in the xbrl keys directory.
    pn.each_child do |filepath|
      xbrl_file = File.open(filepath, "rb")
      xbrl_str = xbrl_file.read
      
      # parse the files for the ftp paths.
      px = ParseXBRLKeys.new
      current_array_of_paths = px.get_zip_file_names(xbrl_str)
      
      # pushes the results to the return object.
      array_of_zips_path.concat current_array_of_paths
      
      puts "finished reading " + filepath.to_s
      index+=1
    end  
    
    return array_of_zips_path
  end
    
end
