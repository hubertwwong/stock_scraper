task :default => 'temp:foo'

namespace :run do

  task :fetch_csv do
    require_relative 'src/main/fetch_stock_symbols'
    require_relative 'src/main/fetch_yahoo_quotes'

    fss = FetchStockSymbols.new
    fss.fetch_all

    fyq = FetchYahooQuotes.new
    fyq.fetch_all
  end

  task :fetch_xbrl_zips do
    require_relative 'src/main/fetch_xbrl_zips'

    fxz = FetchXBRLZips.new
    fxz.fetch_all_zips
  end

  task :save_stock_quotes do
    require_relative 'src/main/save_yahoo_quotes'

    sys = SaveYahooQuotes.new
    sys.save_all_to_db
  end

  task :save_stock_symbols do
    require_relative 'src/main/save_stock_symbols'
    require_relative 'src/main/db_stock_symbols'

    sss = SaveStockSymbols.new
    sss.save_all_to_db

    dss = DBStockSymbols.new
    dss.split_symbols
  end

  task :save_wiki_sp500 do
    require_relative 'src/main/scrape_wiki_sp500'

    sw = ScrapeWikiSP500.new
    sw.run
  end

  task :save_yahoo_prices do
    require_relative 'src/main/scrape_yahoo_prices'

    sy = ScrapeYahooPrices.new
    #sy.scrape_to_csv
    sy.csv_to_db
  end

end

namespace :temp do

  task :foo do
    # can only pass env as strings.
    ENV["COFFEE_CUPS"] = "1"
    cups = ENV["COFFEE_CUPS"]
    require_relative 'temp/foo'
    include Foo
    Foo.hello

  end

end
