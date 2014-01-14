require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/str_util'

describe StrUtil do
  
  describe "str_to_array" do
    it "foo*bar" do
      result = StrUtil.str_to_array "foo*bar"
      
      expect(result).to eq(["foo", "bar"])
    end
    
    it "nil" do
      s = StrUtil.new
      result = StrUtil.str_to_array nil
      
      expect(result).to eq(nil)
    end
  end
  
end