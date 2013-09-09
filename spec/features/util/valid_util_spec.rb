require 'rubygems'

require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/valid_util'

describe ValidUtil do
  
  describe 'test' do
    it 'hello returns true' do
      ValidUtil.hello.should == true
    end
  end
  
  describe 'valid_int' do
    context 'valid' do
      it '132' do
        cur_int = '132'
        ValidUtil.valid_int?(cur_int).should == true
      end
      
      it '132' do
        cur_int = 132
        ValidUtil.valid_int?(cur_int).should == true
      end
    end
    
    context 'invalid' do
      it '000.000' do
        cur_int = '000.000'
        ValidUtil.valid_int?(cur_int).should == false
      end
      
      it 'zzzzz' do
        cur_int = 'zzz'
        ValidUtil.valid_int?(cur_int).should == false
      end
      
      it '123.45.67' do
        cur_int = '123.45.67'
        ValidUtil.valid_int?(cur_int).should == false
      end
      
      it 'nil' do
        cur_int = nil
        ValidUtil.valid_int?(cur_int).should == false
      end
      
      it 'Hash.new' do
        cur_int = Hash.new
        ValidUtil.valid_int?(cur_int).should == false
      end
    end
  end
  
  describe 'valid_money' do
    context 'valid' do
      it '132' do
        cur_money = '132'
        ValidUtil.valid_money?(cur_money).should == true
      end
      
      it '132' do
        cur_money = 132
        ValidUtil.valid_money?(cur_money).should == true
      end
      
      it '12345.67' do
        cur_money = '12345.67'
        ValidUtil.valid_money?(cur_money).should == true
      end
      
      it '12345.67' do
        cur_money = 12345.67
        ValidUtil.valid_money?(cur_money).should == true
      end
    end
    
    context 'invalid' do
      it '000.000' do
        cur_money = '000.000'
        ValidUtil.valid_money?(cur_money).should == false
      end
      
      it 'zzzzz' do
        cur_money = 'zzz'
        ValidUtil.valid_money?(cur_money).should == false
      end
      
      it '123.45.67' do
        cur_money = '123.45.67'
        ValidUtil.valid_money?(cur_money).should == false
      end
      
      it 'nil' do
        cur_money = nil
        ValidUtil.valid_money?(cur_money).should == false
      end
      
      it 'Hash.new' do
        cur_money = Hash.new
        ValidUtil.valid_money?(cur_money).should == false
      end
    end
  end
  
  describe 'valid_date' do
    context 'valid' do
      it '01-01-1970' do
        cur_date = '01-01-1970'
        ValidUtil.valid_date?(cur_date).should == true
      end
      
      it '20130101' do
        cur_date = '20130101'
        ValidUtil.valid_date?(cur_date).should == true
      end
    end
    
    context 'invalid' do
      it '00-00-0000' do
        cur_date = '00-00-0000'
        ValidUtil.valid_date?(cur_date).should == false
      end
      
      it 'zzzzz' do
        cur_date = 'zzzzzz'
        ValidUtil.valid_date?(cur_date).should == false
      end
      
      xit '20130101111' do
        cur_date = '20130101111'
        ValidUtil.valid_date?(cur_date).should == true
      end
    end
  end
  
end