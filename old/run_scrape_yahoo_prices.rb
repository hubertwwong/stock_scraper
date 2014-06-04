require_relative 'src/main/scrape_yahoo_prices'

sy = ScrapeYahooPrices.new
#sy.scrape_to_csv
sy.csv_to_db
