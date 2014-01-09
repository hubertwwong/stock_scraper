require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/save_stock_symbols'

describe SaveStockSymbols do
  
  describe "main" do
    describe "save_to_db" do
      xit "basic" do
        s = SaveStockSymbols.new
        result = s.save_to_db
        
        expect(result).to eq(true)
      end
    end
  end
  
end