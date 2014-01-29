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
  
  describe "download_all" do
    it "basic" do
      url = "ftp.sec.gov"
      files_and_dir = ["/edgar/data/1392902/000151116413000584/", 
                       "/edgar/data/1564618/000119312514012157/0001193125-14-012157-xbrl.zip"]
      dest_dir = "test_data/util/ftp_helper/download_dir/"
      delay = 10 # in seconds
      
      f = FTPHelper.new(:url => url)
      f.connect
      f.download_all(files_and_dir, dest_dir, delay)
      
      expect(f.ftp.last_response_code).to eq("200")
    end
  end
  
  describe "download_dir" do
    xit "basic" do
      url = "ftp.sec.gov"
      source_dir = "/edgar/data/1392902/000151116413000584/"
      dest_dir = "test_data/util/ftp_helper/download_dir/"
      
      f = FTPHelper.new(:url => url)
      f.connect
      f.download_dir(source_dir, dest_dir)
      
      expect(f.ftp.last_response_code).to eq("227")
    end
    
    it "bad dir" do
      url = "ftp.sec.gov"
      source_dir = "/edgar/data/1392902/0001511164130005841111111/"
      dest_dir = "test_data/util/ftp_helper/download_dir/"
      
      f = FTPHelper.new(:url => url)
      f.connect
      f.download_dir(source_dir, dest_dir)
      
      expect(f.ftp.last_response_code).to eq("550")
    end
  end
  
  describe "download_file" do
    xit "basic" do
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