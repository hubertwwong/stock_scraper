require 'sequel_helper'

require_relative '../util/yaml_util'
require_relative '../util/csv_util'
require_relative '../util/valid_util'
require_relative '../util/hash_util'
require_relative '../util/str_util'
require_relative '../util/sequel_helper_factory'
require_relative 'yaml_config_loader'

# db operations involving stock symbol table....
class DBStockSymbols

  attr_accessor :db_user,
                :db_password,
                :db_name,
                :db_table_name,
                :dir_name,
                :csv_col_def

  def initialize(params = {})
    self.init_yaml
    self.init_db
    self.init_dir
  end

  def init_yaml
    @ycl = YAMLConfigLoader.new
    #@db_filename = 'config/database.yml'
    #@@dir_filename = 'config/dir_names.yml'

    # load the yaml file.
    @db_prefs = @ycl.db_prefs
    @dir_prefs = @ycl.dir_prefs
  end

  def init_db
    @db_name = @db_prefs['db_name']
    @db_table_name_stock_quotes = @db_prefs['db_table_name_stock_quotes']
    @db_table_name_stock_symbols = @db_prefs['db_table_name_stock_symbols']
    @sequel_helper = SequelHelperFactory.create
  end

  def init_dir
    @dir_name = @dir_prefs['stock_symbols']
  end

  # main
  ############################################################################

  # import csv will just dump into the db...
  # the issue being that there are some weird characters are present.
  # so you are going to get stuff like "brk^a"
  # different websites have different split mechanisms...
  # this function basically put it in differnt columns..
  #
  # symbol = main symbol
  # sub_symbol_1 = first suffix.
  # sub_symbol_2 = second suffix.
  #
  # its going to do this..
  # 1. read all stock symbol rows.
  # 2. update so you split the symbols to 3 differnt columns...
  def split_symbols
    @sequel_helper.client.fetch("SELECT * FROM " + @db_table_name_stock_symbols) do |row|
      #puts row[:symbol]
      sym_array = StrUtil.str_to_array row[:symbol]
      puts sym_array

      # if the array is nil just move on.
      # you hit an error...
      if sym_array == nil
        next
      elsif sym_array.length == 1
        # might want to remove it...
        # there are some weird symbols that have a seperator without a sub symbol...
        update_ds = @sequel_helper.client["UPDATE " + @db_table_name_stock_symbols + " SET symbol = ? WHERE id = ?", sym_array[0], row[:id]]
        update_ds.update
      elsif sym_array.length == 2
        update_ds = @sequel_helper.client["UPDATE " + @db_table_name_stock_symbols + " SET symbol = ?, sub_symbol_1 = ? WHERE id = ?", sym_array[0], sym_array[1], row[:id]]
        update_ds.update
      elsif sym_array.length == 3
        update_ds = @sequel_helper.client["UPDATE " + @db_table_name_stock_symbols + " SET symbol = ?, sub_symbol_1 = ?, sub_symbol_2 = ? WHERE id = ?", sym_array[0], sym_array[1], sym_array[2], row[:id]]
        update_ds.update
      end
    end

    return true
  end

end
