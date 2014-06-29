require 'sequel_helper'

require_relative '../util/yaml_util'
#require_relative '../util/csv_util'
require_relative '../util/valid_util'
require_relative '../util/hash_util'
require_relative '../util/str_util'
require_relative '../util/sequel_helper_factory'
require_relative 'yaml_config_loader'

# db ops for migrations.
# probably move it later.
class DBMigration

  attr_accessor :db_user,
                :db_password,
                :db_name,
                :db_table_name,
                :dir_name,
                :csv_col_def

  def initialize(params = {})
    self.init_yaml
    self.init_db
  end

  def init_yaml
    @ycl = YAMLConfigLoader.new
    
    # load the yaml file.
    @db_prefs = @ycl.db_prefs
    @dir_prefs = @ycl.dir_prefs
  end

  def init_db
    @db_name = @db_prefs['db_name']
    @sequel_helper = SequelHelperFactory.create
  end


  # main
  ############################################################################

  def run
    return true
  end
    
end
