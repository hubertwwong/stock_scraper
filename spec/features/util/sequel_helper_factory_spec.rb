require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/sequel_helper_factory'

describe SequelHelperFactory do
  
  describe "create" do  
    it "basic" do
      sh = SequelHelperFactory.create
      expect(sh).not_to eq(nil)
    end
  end
  
end