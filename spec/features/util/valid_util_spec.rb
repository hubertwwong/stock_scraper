#require 'rubygems'

require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/valid_util'

describe ValidUtil do

  describe 'test' do
    it 'hello returns true' do
      expect(ValidUtil.hello).to eq(true)
    end
  end

  describe 'valid_int' do
    context 'valid' do
      it '132' do
        cur_int = '132'
        expect(ValidUtil.valid_int?(cur_int)).to eq(true)
      end

      it '132' do
        cur_int = 132
        expect(ValidUtil.valid_int?(cur_int)).to eq(true)
      end
    end

    context 'invalid' do
      it '000.000' do
        cur_int = '000.000'
        expect(ValidUtil.valid_int?(cur_int)).to eq(false)
      end

      it 'zzzzz' do
        cur_int = 'zzz'
        expect(ValidUtil.valid_int?(cur_int)).to eq(false)
      end

      it '123.45.67' do
        cur_int = '123.45.67'
        expect(ValidUtil.valid_int?(cur_int)).to eq(false)
      end

      it 'nil' do
        cur_int = nil
        expect(ValidUtil.valid_int?(cur_int)).to eq(false)
      end

      it 'Hash.new' do
        cur_int = Hash.new
        expect(ValidUtil.valid_int?(cur_int)).to eq(false)
      end
    end
  end

  describe 'valid_money' do
    context 'valid' do
      it '132' do
        cur_money = '132'
        expect(ValidUtil.valid_money?(cur_money)).to eq(true)
      end

      it '132' do
        cur_money = 132
        expect(ValidUtil.valid_money?(cur_money)).to eq(true)
      end

      it '12345.67' do
        cur_money = '12345.67'
        expect(ValidUtil.valid_money?(cur_money)).to eq(true)
      end

      it '12345.67' do
        cur_money = 12345.67
        expect(ValidUtil.valid_money?(cur_money)).to eq(true)
      end
    end

    context 'invalid' do
      it '000.000' do
        cur_money = '000.000'
        expect(ValidUtil.valid_money?(cur_money)).to eq(false)
      end

      it 'zzzzz' do
        cur_money = 'zzz'
        expect(ValidUtil.valid_money?(cur_money)).to eq(false)
      end

      it '123.45.67' do
        cur_money = '123.45.67'
        expect(ValidUtil.valid_money?(cur_money)).to eq(false)
      end

      it 'nil' do
        cur_money = nil
        expect(ValidUtil.valid_money?(cur_money)).to eq(false)
      end

      it 'Hash.new' do
        cur_money = Hash.new
        expect(ValidUtil.valid_money?(cur_money)).to eq(false)
      end
    end
  end

  describe 'valid_date' do
    context 'valid' do
      it '01-01-1970' do
        cur_date = '01-01-1970'
        expect(ValidUtil.valid_date?(cur_date)).to eq(true)
      end

      it '20130101' do
        cur_date = '20130101'
        expect(ValidUtil.valid_date?(cur_date)).to eq(true)
      end
    end

    context 'invalid' do
      it '00-00-0000' do
        cur_date = '00-00-0000'
        expect(ValidUtil.valid_date?(cur_date)).to eq(false)
      end

      it 'zzzzz' do
        cur_date = 'zzzzzz'
        expect(ValidUtil.valid_date?(cur_date)).to eq(false)
      end

      it '20130101111' do
        cur_date = '20130101111'
        expect(ValidUtil.valid_date?(cur_date)).to eq(false)
      end
    end
  end

  describe 'valid_hash_type' do
    context 'valid' do
      it 'foo bar' do
        cur_hash = {:foo => 123, :bar => "zzz"}
        param_hash = {:foo => "i", :bar => "s"}
        expect(ValidUtil.valid_hash_type?(cur_hash, param_hash)).to eq(true)
      end

      it 'dates' do
        cur_hash = {:foo => "2013-08-01", :bar => "zzz"}
        param_hash = {:foo => "d", :bar => "s"}
        expect(ValidUtil.valid_hash_type?(cur_hash, param_hash)).to eq(true)
      end

      it 'money' do
        cur_hash = {:foo => "yyy", :bar => 12.34}
        param_hash = {:foo => "s", :bar => "m"}
        expect(ValidUtil.valid_hash_type?(cur_hash, param_hash)).to eq(true)
      end
    end

    context 'invalid' do
      it 'nil' do
        cur_hash = nil
        param_hash = nil
        expect(ValidUtil.valid_hash_type?(cur_hash, param_hash)).to eq(false)
      end

      it 'missing type' do
        cur_hash = {:foo => 123}
        param_hash = {:foo => "i", :bar => "s"}
        expect(ValidUtil.valid_hash_type?(cur_hash, param_hash)).to eq(false)
      end

      it 'wrong type' do
        cur_hash = {:foo => 123, :bar => "zzz"}
        param_hash = {:foo => "s", :bar => "i"}
        expect(ValidUtil.valid_hash_type?(cur_hash, param_hash)).to eq(false)
        #expect(ValidUtil.valid_hash_type?(cur_hash, param_hash)).to eq(3)
      end
    end
  end

end
