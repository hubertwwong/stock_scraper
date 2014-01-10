require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/save_stock_symbols'

describe SaveStockSymbols do
  
  describe "main" do
    describe "save_all_to_db" do
      xit "basic" do
        s = SaveStockSymbols.new
        result = s.save_all_to_db
        
        expect(result).to eq(true)
      end
    end
    
    describe "save_to_db" do
      it "basic" do
        s = SaveStockSymbols.new
        filename = "/home/user/.stock_scraper/csv/stock_symbols/nyse.csv"
        exchange = "NYSE"
        result = s.save_to_db(exchange, filename)
        
        expect(result).to eq(true)
      end
    end
  end
  
end