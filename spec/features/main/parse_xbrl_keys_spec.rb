require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/parse_xbrl_keys'

describe ParseXBRLKeys do
  
  describe 'main' do
    describe "get_zip_file_names" do
      before(:each) do
        @file = File.open("test_data/main/xbrl_key/xbrlrss-2013-12.xml", "rb")
        @contents = @file.read
        @file.close
      end
      
      it "should return true" do
        f = ParseXBRLKeys.new
        
        expect(f.get_zip_file_names(@contents).length).to be > 100
      end
    end
  end
  
end