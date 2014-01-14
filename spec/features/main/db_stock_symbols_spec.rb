require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/db_stock_symbols'

describe DBStockSymbols do
  
  describe "main" do
    describe "split_symbols" do
      it "basic" do
        s = DBStockSymbols.new
        result = s.split_symbols
        
        expect(result).to eq(true)
      end
    end
    
    describe "symbol_to_array" do
      it "foo*bar" do
        s = DBStockSymbols.new
        result = s.symbol_to_array "foo*bar"
        
        expect(result).to eq(["foo", "bar"])
      end
      
      it "nil" do
        s = DBStockSymbols.new
        result = s.symbol_to_array nil
        
        expect(result).to eq(nil)
      end
    end
  end
  
end