require_relative 'src/main/scrape_yahoo_prices'

sy = ScrapeYahooPrices.new
#result_hash = sy.visit_and_get_csv('YHOO')
#result = sy.save_to_db(result_hash)
sy.run_sp500
