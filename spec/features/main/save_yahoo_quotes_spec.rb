require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/save_yahoo_quotes'

describe SaveYahooQuotes do
  
  describe "main" do
    describe "save_to_db" do
      it "AAPL" do
        s = SaveYahooQuotes.new()
        result = s.save_to_db("AAPL", "AAPL.csv")
        expect(result).to eq(true)
      end
    end
  end
  
end