#require 'rspec/core/rake_task'



# change this for default task when you run bundle exec rake
task :default => ['test:main']

# change this for task when you run run bundle exec rake all
# broken
#task :all => ['temp:foo']



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



# runs rake something...
#
# put in a env variable to control what db its hits.
namespace :test do

  task :main do
    # set the env variable.
    # for now, its just a db switch statement.
    # for the name of the db to access.
    ENV['STOCK_SCRAPER_ENV'] = "test"
    puts ENV['STOCK_SCRAPER_ENV']
    
    # runs rspec. need to fix this at some point to use the db.
    system "rspec"
    #puts "done"
  end

end

# stuck onn this...
# probably a better way
#
#desc "Run the specs."
#RSpec::Core::RakeTask.new(:spec)
#RSpec::Core::RakeTask.new do |t|
#  t.pattern = "spec/**/*_spec.rb"
#end
#
# URLS
# http://stackoverflow.com/questions/15168086/how-to-create-an-rspec-rake-task-using-rspeccoreraketask
# https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task

# delete or ignore this.
# just testing to see how rake env works.
namespace :temp do

  task :foo do
    # can only pass env as strings.
    ENV["COFFEE_CUPS"] = "1"
    cups = ENV["COFFEE_CUPS"]
    require_relative 'temp/foo'
    include Foo
    Foo.hello
  end


  # if you want to have multiple build env based off a variable
  #task :build do |t, args|
  #  puts "Current env is #{ENV['RAKE_ENV']}"
  #end

end