require_relative 'yaml_util'

# sets up a sequel helper objects
# and returns it.
class SequelHelperFactory
  
  # returns a sql helper object
  def self.create
    db_filename = 'config/database.yml'
    
    # load the yaml file.
    db_prefs = YamlUtil.read(db_filename)
    
    # load db params from yaml file.
    db_user = db_prefs['db_user']
    db_password = db_prefs['db_password']
    db_host = db_prefs['db_url']
    database = db_prefs['db_name']
    db_adapter = db_prefs['db_adapter']
    
    # put results into a hash..
    final_params = {adapter: db_adapter,
                    host: db_host,
                    user: db_user,
                    password: db_password,
                    database: database}
    
    # init.
    sh = SequelHelper.new final_params
    
    # connect and return SequelHelper object.
    return sh.connect
  end
  
end