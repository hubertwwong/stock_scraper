require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/scrape_yahoo_prices'

# loading capybara to load pages to test the utils functions.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

describe ScrapeYahooPrices do
  
  describe 'test' do
    it 'hello returns true' do
      s = ScrapeYahooPrices.new
      s.hello.should == true
    end  
  end
  
  describe 'main' do
    describe 'visit_and_get_csv' do
      before(:each) do
        @s = ScrapeYahooPrices.new
      end
      
      xit 'should contain GS' do
        result = @s.visit_and_get_csv('GS')
        result.length.should >= 100
      end
    end
    
    describe 'save_to_db' do
      before(:each) do
        @s = ScrapeYahooPrices.new
      end
      
      xit 'should contain GS' do
        result_csv = @s.visit_and_get_csv('GS')
        #puts result_csv
        result = @s.save_csv_to_db(result_csv, 'GS')
        result.should == true
      end
    end
    
    describe 'csv_to_db' do
      before(:each) do
        @s = ScrapeYahooPrices.new
      end
      
      it 'should contain GS' do
        result_csv = @s.csv_to_db
        result_csv.should == true
      end
    end
  end
  
  describe 'util' do
    describe 'create_url' do
      before(:each) do
        @s = ScrapeYahooPrices.new
      end
      
      it 'should contain GS' do
        url = @s.create_url('GS')
        result = /GS/.match(url)
        puts url
        result.should == true
      end
    end
  end
  
end