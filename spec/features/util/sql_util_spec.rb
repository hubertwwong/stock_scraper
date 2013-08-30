require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/sql_util'

require 'rubygems'

describe SqlUtil do
  
  describe "test_01 db" do
    before(:each) do
      @user = 'root'
      @password = 'password'
      @url = 'localhost'
      @db_name = 'test01'
      
      # load account details.
      @db = SqlUtil.new(:url => @url, 
                        :user=> @user, 
                        :password => @password, 
                        :db_name => @db_name)
    end
    
    describe "misc methods" do
      describe "server_version" do
        it "returns a string" do
          result = @db.server_version
          result.should include 'Server version'
        end
      end
    end
    
    describe "string methods" do
      describe "and_helper" do
        it "handles 2 items" do
          col_names = ['val', 'another_val']
          col_values = [2, 3]
          result = SqlUtil.and_helper(col_names, col_values)
          result.should == 'val = 2 AND another_val = 3'
        end
      end
      
      describe "quote_on_string" do
        it "does nothing for numbers" do
          result = SqlUtil.quote_on_string(4)
          result.should == 4
        end
        
        it "adds quotes to strings" do
          result = SqlUtil.quote_on_string('4')
          result.should == "\'4\'"
        end
      end
    end
    
    describe "util methods" do
      describe "num_rows" do
        it "car db returns 3" do
          result = @db.num_rows('car')
          result.should > 0
        end
      end
      
      describe "hash_array" do
        it "return a hash off 2 arrays" do
          arr1 = ['a', 'b', 'c']
          arr2 = ['d', 'e', 'f']
          result = @db.hash_arrays(arr1, arr2)
          result.should == {'a' => 'd', 'b' => 'e', 'c' => 'f'}
        end
      end
    
      describe "hash_get_keys_as_str" do
        it "returns a comma seperated string" do
          arr1 = {'a' => 'd', 'b' => 'e', 'c' => 'f'}
          result = @db.hash_get_keys_as_str(arr1)
          result.should == 'a, b, c'
        end
      end
    
      describe "hash_get_values_as_str" do
        it "returns a space seperated string" do
          arr1 = {'a' => 'd', 'b' => 'e', 'c' => 'f'}
          result = @db.hash_get_values_as_str(arr1)
          result.should == "'d', 'e', 'f'"
        end
      end
    end
    
    describe "read methods" do
      describe "read_last_row" do
        it "car db order by make will return toyota" do
          result = @db.read_last_row('car', 'make')
          result['make'].should == 'zzz999'
        end
      end
      
      describe "read_one_param" do
        it "car db order by make will return toyota" do
          result = @db.read_with_one_param('car', 'make', 'foo')
          result['model'].should == 'bar'
        end
      end
      
      describe "read_where" do
        it "car db order by make will return toyota" do
          col_names = ['make']
          col_vals = ['foo']
          result = @db.read_where('car', col_names, col_vals)
          result['model'].should == 'bar'
        end
      end
      
      describe "read_col_names" do
        it "car db returns id, name, model array" do
          result = @db.read_col_names('car')
          result.should == ['id', 'make', 'model']
        end
      end
    end
    
    # fix this later. the replace one just returns false...
    # probably want some useful info about this.
    describe "insert methods" do
      describe "replace_one" do
        it "car db returns id, name, model array" do
          vals = {'id' => '5', 'make' => 'xxxx', 'model' => 'omfg'}
          result = @db.replace_one('car', vals)
          result.should == true
        end
      end
    end
  end
    
end
