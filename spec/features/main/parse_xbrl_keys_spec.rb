require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/parse_xbrl_keys'

describe ParseXBRLKeys do
  
  describe 'main' do
    describe "fetch_all" do
      it "should return true" do
        f = ParseXBRLKeys.new
        
        expect(f.fetch_all).to eq(true)
      end
    end
  end
  
end