require_relative 'src/main/scrape_yahoo_prices'

sy = ScrapeYahooPrices.new
result_csv = sy.visit_and_get_csv('YHOO')
result = sy.save_csv_to_db(result_csv, 'YHOO')
