require_relative 'src/main/save_stock_symbols'
require_relative 'src/main/db_stock_symbols'

sss = SaveStockSymbols.new
sss.save_all_to_db

dss = DBStockSymbols.new
dss.split_symbols