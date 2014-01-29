require 'net/ftp'

require_relative '../util/yaml_util'
require_relative '../util/file_wrapper_util'
require_relative '../util/ftp_helper'


# fetching xml files containing the all xbrl locations.
# probably will have another file to parse it and fetch it.
class FetchXBRLKeys
  
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
    @dir_name = @dir_prefs['sec_edgar_ftp']
    puts @dir_name
  end  
  
  def init_sec
    @sec_base_url = @sec_prefs['base_url']
    @sec_xbrl_keys_dir = @sec_prefs['xbrl_keys_dir']
    #puts @sec_base_url
    #puts @sec_xbrl_keys_dir
  end
  
  # main
  ############################################################################
  
  def fetch_all
    #puts ">>SEC>>>"
    #puts @sec_xbrl_keys_dir
    #puts @dir_name
    #puts ">>SEC>>>"
    
    f = FTPHelper.new(:url => @sec_base_url)
    f.connect
    f.download_all([@sec_xbrl_keys_dir], @dir_name)
    f.disconnect
      
    return true
  end
  
end
