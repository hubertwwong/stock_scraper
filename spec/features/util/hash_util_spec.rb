#require 'rubygems'

require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/hash_util'

describe HashUtil do

  describe "add_constant to array hash" do
    it 'foo bar baz' do
      cur_array = Array.new
      cur_hash = {:foo => 1, :bar=> 2}
      cur_hash2 = {:foo => 100, :bar=> 200}
      cur_array << cur_hash
      cur_array << cur_hash2
      new_hash = {:baz => 3}

      result = HashUtil.add_constant_to_array_hash(cur_array, new_hash)
      result_for_baz = result[1][:baz]
      result_for_foo = result[1][:foo]
      expect(result_for_baz).to eq(3)
      expect(result_for_foo).to eq(100)
    end
  end

  describe "add_constant" do
    it 'foo bar baz' do
      cur_hash = {:foo => 1, :bar=> 2}
      new_hash = {:baz => 3}

      result = HashUtil.add_constant(cur_hash, new_hash)
      result_for_baz = result[:baz]
      result_for_foo = result[:foo]
      expect(result_for_baz).to eq(3)
      expect(result_for_foo).to eq(1)
    end
  end

  describe "test" do
    it 'hello return true' do
      expect(HashUtil.hello).to eq(true)
    end
  end

end
