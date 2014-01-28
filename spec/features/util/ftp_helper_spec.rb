require 'rubygems'

require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/ftp_helper'

describe FTPHelper do
  
  describe "connect" do
    it "basic" do
      url = "ftp.sec.gov"
      f = FTPHelper.new(:url => url)
      f.connect
      
      expect(f.ftp.last_response_code).to eq("200")
    end
  end
  
  describe "download_dir" do
    it "basic" do
      url = "ftp.sec.gov"
      source_dir = "/edgar/data/1392902/000151116413000584/"
      dest_dir = "test_data/util/ftp_helper/download_dir/"
      
      f = FTPHelper.new(:url => url)
      f.connect
      f.download_dir(source_dir, dest_dir)
      
      expect(f.ftp.last_response_code).to eq("226")
    end
  end
  
  describe "download_file" do
    it "basic" do
      url = "ftp.sec.gov"
      source_file = "/edgar/data/1392902/000151116413000584/0001511164-13-000584-xbrl.zip"
      dest_dir = "test_data/util/ftp_helper/"
      
      f = FTPHelper.new(:url => url)
      f.connect
      f.download_file(source_file, dest_dir)
      
      expect(f.ftp.last_response_code).to eq("226")
    end
  end
  
end