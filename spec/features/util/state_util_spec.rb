require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../../src/util/state_util'

describe StateUtil do
  it "CA returns CALIFORNIA" do
    result = StateUtil.abbv_to_state('CA')
    result.should == 'CALIFORNIA'
  end
  
  it "MP returns NORTHERN MARIANA ISLANDS" do
    result = StateUtil.abbv_to_state('MP')
    result.should == 'NORTHERN MARIANA ISLANDS'
  end
  
  it "zzzzz returns false" do
    result = StateUtil.abbv_to_state('zzzzz')
    result.should == nil
  end
end