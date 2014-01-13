require_relative 'src/main/fetch_stock_symbols'
require_relative 'src/main/fetch_yahoo_quotes'

fss = FetchStockSymbols.new
fss.fetch_all

fyq = FetchYahooQuotes.new
fyq.fetch_all