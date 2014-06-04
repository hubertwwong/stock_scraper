require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/fetch_xbrl_zips'

describe FetchXBRLZips do
  
  describe 'main' do
    describe "fetch_all" do
      xit "should return true" do
        f = FetchXBRLZips.new
        
        expect(f.fetch_all_zips).to eq(true)
      end
    end
    
    describe "fetch_all" do
      xit "should return true" do
        f = FetchXBRLZips.new
        
        expect(f.fetch_all_keys.length).to be(100)
      end
    end
  end
  
end