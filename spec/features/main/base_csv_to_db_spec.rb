require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/base_csv_to_db'

describe BaseCsvToDb do
  
  describe "main" do
    before(:each) do
      @params = {:base_dir => "/home/user/"}
    end
    
    describe "save to db" do
      it "base" do
        
        csv_params = {:filename => "/home/user/fleet.csv",
              :line_term_by => "\r\n",
              :col_names => ["@dummy", "name", "description"]}
                         
        params = {:csv_params => csv_params,
                  :table_name => "fleet",
                  :table_cols => ["name", "description"],
                  :key_cols => ["name"]}
                  
        #csv_params = {
        #      :ignore_flag => true,
        #      :fields_term_by => "\t",
        #      :line_term_by => "\r\n",
        #      :skip_num_lines => 1,
        #      :col_names => ["@dummy", "name", "description"],
        #      :set_col_names => ["name='zzzz'"]}
        #table_name = "fleet"
        #filename = "fleet.csv"
        #save_params = {:table_name => table_name,
        #          :filename => filename,
        #          :sql_params => csv_params}
        #
        f = BaseCsvToDb.new(@params)
        
        # need to change the db...
        # the class defaults for the to stock4.deveopment.
        f.connect(:db_name => "space_ship")
        
        #expect(f.save_to_db(save_params)).to eq(true)
        expect(f.save_to_db(params)).to eq(true)
      end
    end
  end
  
  describe "test" do
    xit "hello returns true" do
      f = BaseCsvToDb.new
      expect(f.hello).to eq("hello")
    end  
  end
  
end