require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/util/yaml_util'

describe YamlUtil do

  describe 'main' do
    before(:each) do
      @filename = 'config/foo.yml'
    end

    describe 'read' do
      it "cur_pos exist" do
        result = YamlUtil.read(@filename)
        expect(result['cur_pos']).to be > 0
      end
    end

    describe 'write' do
      xit "cur_pos updates" do
        config.store('cur_pos', '1111')
        result = YamlUtil.write(@filename, result)
        expect(config).not_to be_nil
      end
    end

    describe 'read / write' do
      it "cur_pos updates" do
        cur_yml = YamlUtil.read(@filename)
        cur_yml.store('cur_pos', 123)
        puts cur_yml.inspect
        result = YamlUtil.write(@filename, cur_yml)

        expect(result).not_to be_nil
      end
    end
  end

  describe 'exp' do
    before(:each) do
      @filename = 'config/test.yml'
      @filename2 = 'config/test.yml'
    end

    xit 'multiple yml files' do
      cur_yml = YamlUtil.read(@filename)
      cur_yml2 = YamlUtil.read(@filename2)

      expect(cur_yml['foo']['bar']).to eq(1)
      #expect(cur_yml2['fiz']['bar']).to eq(nil)
    end
  end

end
