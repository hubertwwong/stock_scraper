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
  
  describe 'misc' do
    describe "create_url" do
      xit "GS" do
        f = FetchYahooQuotes.new
        symbol = "GS"
        expected_url = "http://ichart.finance.yahoo.com/table.csv?s=GS&d=7&e=27&f=2015&g=d&a=3&b=12&c=1900&ignore=.csv"
        
        expect(f.create_url(symbol)).to eq(expected_url)
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