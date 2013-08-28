require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/scrape_util'

# loading capybara to load pages to test the utils functions.
require 'rubygems'
require 'capybara'
require 'capybara/dsl'

describe ScrapeUtil do
  
  include Capybara::DSL
  #Capybara.default_driver = :selenium
  
  describe 'has_content_and?' do
    xit "links on the bottom of page should return true" do
      visit 'http://www.google.com'
      
      strs = ['About Google', '+Google']
      result = ScrapeUtil.has_content_and?(page, strs)
      
      result.should be_true
    end
    
    xit "gibberish should return false" do
      visit 'http://www.google.com'
      
      strs = ['jkldsfkl', 'adsfdfasfd']
      result = ScrapeUtil.has_content_and?(page, strs)
      
      result.should be_false
    end
  end
  
  describe 'has_content_or?' do
    xit "link on the bottom should be true" do
      
      visit 'http://www.google.com'
      
      strs = ['About Google', 'aaaaa']
      result = ScrapeUtil.has_content_or?(page, strs)
      
      result.should be_true
    end
    
    xit "gibberish should be false" do
      
      visit 'http://www.google.com'
      
      strs = ['zzzzzz', 'aaaaa']
      result = ScrapeUtil.has_content_or?(page, strs)
      
      result.should be_false
    end
  end  
end
