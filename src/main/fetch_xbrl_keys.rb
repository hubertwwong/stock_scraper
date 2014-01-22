require 'net/ftp'

require_relative '../util/yaml_util'
require_relative '../util/file_wrapper_util'

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
    @dir_name = @dir_prefs['xbrl_keys']
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
    puts "fetching xbrl key files"
    puts @dir_name
    
    ftp = Net::FTP.new(@sec_base_url)
    ftp.passive = true
    #puts "1." + ftp.last_response.to_s
    ftp.login
    #puts "2." + ftp.last_response.to_s
    #files = ftp.list
    ftp.chdir(@sec_xbrl_keys_dir)
    #puts "3." + ftp.last_response.to_s
    #files = ftp.ls
    #ftp.getbinaryfile('nif.rb-0.91.gz', 'nif.gz', 1024)
    
    # create a directory if needed.
    # so things... this is broken....
    FileWrapperUtil.mkdir_p(@dir_name)
    
    # grab the files...
    ftp.nlst.each do |f|
      puts ">" + f + "<"
      ftp_file = "/" + @sec_xbrl_keys_dir + f
      local_file = @dir_name + f
      ftp.gettextfile(f, local_file)
    end
    
    #puts files
    
    # close ftp conneciton.
    ftp.close
    
    return false
  end
  
end
