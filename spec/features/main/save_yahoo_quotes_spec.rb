require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/save_yahoo_quotes'

describe SaveYahooQuotes do
  
  describe "main" do
    describe "save_all_to_db" do
      xit "basic" do
        s = SaveYahooQuotes.new
        result = s.save_all_to_db
        
        expect(result).to eq(true)
      end
    end
    
    describe "save_to_db" do
      xit "AAPL" do
        s = SaveYahooQuotes.new
        result = s.save_to_db("AAPL", "AAPL.csv")
        expect(result).to eq(true)
      end
    end
  end
  
end