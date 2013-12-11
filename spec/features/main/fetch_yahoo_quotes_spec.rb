require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/fetch_yahoo_prices'

# loading capybara to load pages to test the utils functions.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

describe FetchYahooQuotes do
  
  describe 'test' do
    it 'hello returns true' do
      f = FetchYahooQuotes.new
      f.hello.should == true
    end  
  end
  
end