require_relative '../util/yaml_util'

# moving all YAML config files into this file.
#
class YAMLConfigLoader

  attr_accessor :browser_prefs, :db_prefs, :dir_prefs, :sec_prefs, :scraper_prefs

  def initialize
    @browser_filename = 'config/browser.yml'
    @db_filename = 'config/database.yml'
    @dir_filename = 'config/dir_names.yml'
    @sec_filename = 'config/sec_urls.yml'
    @scraper_filename = 'config/yahoo_progress.yml'

    # load the yaml file.
    @browser_prefs = YamlUtil.read(@browser_filename)
    @db_prefs = YamlUtil.read(@db_filename)
    @dir_prefs = YamlUtil.read(@dir_filename)
    @sec_prefs = YamlUtil.read(@sec_filename)
    @scraper_prefs = YamlUtil.read(@scraper_filename)
  end

end
