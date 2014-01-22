require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/fetch_xbrl_keys'

describe FetchXBRLKeys do
  
  describe 'main' do
    describe "fetch_all" do
      it "should return true" do
        f = FetchXBRLKeys.new
        
        expect(f.fetch_all).to eq(true)
      end
    end
  end
  
end