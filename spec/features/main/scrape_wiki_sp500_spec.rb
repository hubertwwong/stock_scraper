require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/scrape_wiki_sp500'

# loading capybara to load pages to test the utils functions.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

describe ScrapeWikiSP500 do
  
  describe 'test' do
    it 'hello returns true' do
      s = ScrapeWikiSP500.new
      s.hello.should == true
    end  
  end
  
  describe 'main' do
    describe 'visit_and_parse' do
      before(:each) do
        @s = ScrapeWikiSP500.new
      end
      
      it 'should be true' do
        result = @s.visit_and_parse
        result.should >= 10
      end
    end
  end
  
end