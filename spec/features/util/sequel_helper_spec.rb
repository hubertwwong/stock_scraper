require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/sequel_helper'

require 'rubygems'

describe SequelHelper do
  
  describe "test" do
    it 'hello return true' do
      SequelHelper.hello.should == true
    end
  end
  
  describe "insert_methods" do
    before(:each) do
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      
      # load account details.
      @db = SequelHelper.new(:url => @url, 
                        :user=> @user, 
                        :password => @password, 
                        :db_name => @db_name)
    end
    
    describe "insert" do
      it "should return true" do
        table_name = 'car'
        params = {:make => 'zzzzzzzzzz', :model => 'zzzzzzzzzzzzzzz'}
        result = @db.insert(table_name, params)
        result.should == true
      end
    end
    
    describe "insert_where" do
      it "should return true" do
        table_name = 'car'
        params = {:make => 'yyyyy', :model => 'yyyyy'}
        result = @db.insert_unique(table_name, params)
        result.should == false
      end
    end
  end
  
  describe "read_methods" do
    before(:each) do
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      
      # load account details.
      @db = SequelHelper.new(:url => @url, 
                        :user=> @user, 
                        :password => @password, 
                        :db_name => @db_name)
    end
    
    describe "read" do
      it "should return true" do
        result = @db.read_all('car')
        result.length.should > 1
      end
    end
    
    describe "read_where" do
      it "should return true" do
        table_name = 'car'
        params = {:make => 'toyota'}
        result = @db.read_where(table_name, params)
        result.length.should == 1
      end
    end
  end
  
  describe "query_methods" do
    before(:each) do
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      
      # load account details.
      @db = SequelHelper.new(:url => @url, 
                        :user=> @user, 
                        :password => @password, 
                        :db_name => @db_name)
    end
    
    describe "row_exist?" do
      it "should return true" do
        table_name = 'car'
        params = {:make => 'toyota'}
        result = @db.row_exist?(table_name, params)
        result.should == true
      end
    end
  end
  
  describe "query_methods : stock_symbols" do
    before(:each) do
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'stock4_development'
      
      # load account details.
      @db = SequelHelper.new(:url => @url, 
                        :user=> @user, 
                        :password => @password, 
                        :db_name => @db_name)
    end
    
    describe "row_exist?" do
      it "should return true" do
        table_name = 'stock_symbols'
        params = {:symbol =>"MMM", :company_name=>"3M Co."}
        result = @db.row_exist?(table_name, params)
        result.should == true
      end
    end
  end
  
end