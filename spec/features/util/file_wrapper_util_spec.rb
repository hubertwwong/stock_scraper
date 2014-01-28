require 'rubygems'

require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/file_wrapper_util'

describe FileWrapperUtil do
  
  describe "mv" do
    before(:each) do
      base_dir = "test_data/util/file_wrapper_util/"
      src = base_dir + "start.txt"
      dest = base_dir + "foo.txt"
      
      # wipe the bar directory.
      FileWrapperUtil.rm_rf(base_dir + "bar/")
      
      # do a copy of the start file to foo.txt
      FileWrapperUtil.cp(src, dest)
    end
    
    it 'basic' do
      base_dir = "/test_data/util/file_wrapper_util/"
      src = base_dir + "foo.txt"
      dest = base_dir + "bar/bar.txt"
      FileWrapperUtil.mv(src, dest)
      result = File.exist?(dest)
      
      expect(result).to eq(true)
    end
  end
  
end