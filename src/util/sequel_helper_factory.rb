require_relative 'yaml_util'

# sets up a sequel helper objects
# and returns it.
#
# TODO:
# return a singualar object.
# factory i don't think make sense.
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
    db_adapter = db_prefs['db_adapter']
    
    # checks the env. set the db name correctly.
    # NOTE... USING ENV variables.
    if ENV['STOCK_SCRAPER_ENV'] == 'test'
      database = db_prefs['db_name_test']
    elsif ENV['STOCK_SCRAPER_ENV'] == 'dev'
      database = db_prefs['db_name_dev']
    elsif ENV['STOCK_SCRAPER_ENV'] == 'prod'
      database = db_prefs['db_name_prod']
    else
      # default to test db.
      database = db_prefs['db_name_test']
    end
      
    # put results into a hash..
    final_params = {adapter: db_adapter,
                    host: db_host,
                    user: db_user,
                    password: db_password,
                    database: database}
    
    # init and connect to db.
    sh = SequelHelper.new final_params
    sh.connect
    
    # adding some logging to std out.
    # docs have an error.. its Logger not Loggers
    sh.client.sql_log_level = :debug
    sh.client.loggers << Logger.new($stdout)
    
    # connect and return SequelHelper object.
    return sh
  end
  
end