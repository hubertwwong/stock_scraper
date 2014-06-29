require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/db_migration'

describe DBMigration do

  describe "main" do
    describe "run" do
      it "basic" do
        s = DBMigrate.new
        result = s.run
        puts "zzzzzzzzzzzzzzzzzzzzzzz" 
        expect(result).to eq(false)
      end
    end
  end

  describe "db create" do
    it "foo" do
      expect(nil).to eq(nil)
    end
  end
end