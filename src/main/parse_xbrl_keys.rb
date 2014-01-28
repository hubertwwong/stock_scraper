require 'net/ftp'

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

  
end