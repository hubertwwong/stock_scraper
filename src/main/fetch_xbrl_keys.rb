require 'net/ftp'

require_relative '../util/yaml_util'

# fetching xml files containing the all xbrl locations.
# probably will have another file to parse it and fetch it.
class FetchXBRLKeys
  
  def initialize(params = {})
    self.init_yaml
    self.init_dir
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
    @dir_name = @dir_prefs['xbrl_keys']
  end  
  
  def init_sec
    @sec_base_url = @sec_prefs['base_url']
    @sec_xbrl_keys_dir = @sec_prefs['xbrl_keys_dir']
  end
  
  # main
  ############################################################################
  
  def fetch_all
    puts "fetching xbrl key files"
    
    ftp = Net::FTP.new(@sec_base_url)
    ftp.passive = true
    ftp.login
    files = ftp.chdir(@sec_xbrl_keys_dir)
    files = ftp.list
    #ftp.getbinaryfile('nif.rb-0.91.gz', 'nif.gz', 1024)
    ftp.close
    
    return false
  end
  
end
