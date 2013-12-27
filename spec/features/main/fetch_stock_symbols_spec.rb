require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/fetch_stock_symbols'

describe FetchStockSymbols do
  
  describe "scrape_csv" do
    it "basic" do
      fss = FetchStockSymbols.new
      
      expect(fss.fetch_all).to eq(true)
    end
  end
  
end