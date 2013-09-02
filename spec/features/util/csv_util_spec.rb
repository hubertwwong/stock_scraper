require 'rubygems'

require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/csv_util'

describe CsvUtil do
  
  describe "test" do
    it 'hello return true' do
      CsvUtil.hello.should == true
    end
  end
  
  describe "to_array_of_hashes" do
    it 'basic' do
      csv_str = "foo,bar,baz\n" +
                "aaa,bbb,ccc\n" +
                "ddd,eee,fff"
      params = {:a_a => 0, :b_a => 1, :c_a => 2}
      result = CsvUtil.to_array_of_hashes(csv_str, params, true, nil)
      result.length.should > 1
    end
    
    it 'basic with optional hash' do
      csv_str = "foo,bar,baz\n" +
                "aaa,bbb,ccc\n" +
                "ddd,eee,fff"
      opt_param = {:foo => true}
      params = {:a_a => 0, :b_a => 1, :c_a => 2}
      result = CsvUtil.to_array_of_hashes(csv_str, params, true, opt_param)
      puts result
      result.length.should > 1
    end
  end

  describe "fetch_csv_from_url" do
    xit 'basic' do
      user_agent = nil
      web_url = 'http://ichart.finance.yahoo.com/table.csv?s=GS&d=7&e=27&f=2015&g=d&a=3&b=12&c=1900&ignore=.csv'
      result = CsvUtil.fetch_csv_from_url(web_url, user_agent)
      puts result
      result.length.should > 1000
    end
  end

end