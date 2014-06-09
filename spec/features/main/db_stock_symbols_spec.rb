require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/db_stock_symbols'

describe DBStockSymbols do

  describe "main" do
    describe "split_symbols" do
      xit "basic" do
        s = DBStockSymbols.new
        result = s.split_symbols

        expect(result).to eq(true)
      end
    end
  end

end