require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/fetch_yahoo_quotes'

describe FetchYahooQuotes do
  
  describe 'main' do
    describe "fetch_all" do
      xit "should return true" do
        f = FetchYahooQuotes.new
        
        expect(f.fetch_all).to eq(expected_url)
      end
    end
  end
  
  describe 'helper' do
    describe "create_url" do
      it "GS" do
        f = FetchYahooQuotes.new
        symbol = "GS"
        expected_url = "http://ichart.finance.yahoo.com/table.csv?s=GS&d=0&e=1&f=2020&g=d&a=0&b=1&c=1900&ignore=.csv"
        
        expect(f.create_url(symbol, nil, nil)).to eq(expected_url)
      end
      
      it "BRK-A" do
        f = FetchYahooQuotes.new
        symbol = "BRK"
        sub_symbol_1 = "A"
        sub_symbol_2 = nil
        expected_url = "http://ichart.finance.yahoo.com/table.csv?s=BRK-A&d=0&e=1&f=2020&g=d&a=0&b=1&c=1900&ignore=.csv"
        
        expect(f.create_url(symbol, sub_symbol_1, sub_symbol_2)).to eq(expected_url)
      end
      
      it "GS" do
        f = FetchYahooQuotes.new
        symbol = "GS"
        sub_symbol_1 = nil
        sub_symbol_2 = nil
        start_date = "2013-01-01"
        
        expected_url = "http://ichart.finance.yahoo.com/table.csv?s=GS&d=0&e=1&f=2020&g=d&a=0&b=01&c=2013&ignore=.csv"
        
        expect(f.create_url(symbol, nil, nil, start_date)).to eq(expected_url)
      end
    end
  end
  
  describe 'test' do
    xit 'hello returns true' do
      f = FetchYahooQuotes.new
      expect(f.hello).to eq(true)
    end  
  end
  
end