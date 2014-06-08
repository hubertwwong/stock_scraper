require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/yaml_config_loader'

describe YAMLConfigLoader do

  describe "main" do
    describe "load_files" do
      it "main" do
        ycl = YAMLConfigLoader.new

        expect(ycl).not_to eq(nil)
      end
    end

    describe "params" do
      it "main" do
        ycl = YAMLConfigLoader.new

        expect(ycl.db_prefs['db_user']).to eq('root')
      end
    end
  end

end
