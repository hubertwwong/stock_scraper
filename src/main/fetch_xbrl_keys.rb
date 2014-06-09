require 'net/ftp'

require_relative '../util/yaml_util'
require_relative '../util/file_wrapper_util'
require_relative '../util/ftp_helper'
require_relative 'yaml_config_loader'

# fetching xml files containing the all xbrl locations.
# probably will have another file to parse it and fetch it.
class FetchXBRLKeys
  
  def initialize(params = {})
    self.init_yaml
    self.init_dir
    self.init_sec
  end
  
  def init_yaml
    @ycl = YAMLConfigLoader.new
      
    # load the yaml file.
    @db_prefs = @ycl.db_prefs
    @dir_prefs = @ycl.dir_prefs
    @sec_prefs = @ycl.sec_prefs  
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
