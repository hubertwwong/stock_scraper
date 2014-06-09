require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/scrape_nasdaq_symbols'

# loading capybara to load pages to test the utils functions.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

describe ScrapeNasdaqSymbols do
  
  describe 'scrape_to_csv' do
    xit 'returns true' do
      sns = ScrapeNasdaqSymbols.new
      result = sns.scrape_to_csv
      result.should == true
    end
  end
  
  describe 'test' do
    xit 'hello returns true' do
      ScrapeNasdaqSymbols.hello.should == true
    end  
  end
  
end