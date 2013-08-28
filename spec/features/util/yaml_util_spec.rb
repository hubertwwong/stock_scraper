require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/yaml_util'

describe YamlUtil do
  
  before(:each) do
    @filename = 'config/foo.yml'
  end
  
  describe 'read' do
    xit "cur_pos exist" do
      result = YamlUtil.read(@filename)
      result['cur_pos'].should > 0
    end
  end
  
  describe 'write' do
    xit "cur_pos updates" do
      config.store('cur_pos', '1111')
      result = YamlUtil.write(@filename, result)
      config.should_not be_nil
    end
  end
  
  describe 'read / write' do
    it "cur_pos updates" do
      cur_yml = YamlUtil.read(@filename)
      cur_yml.store('cur_pos', 123)
      puts cur_yml.inspect
      result = YamlUtil.write(@filename, cur_yml)
      
      result.should_not be_nil
    end
  end
  
end