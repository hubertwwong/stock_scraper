require File.dirname(__FILE__) + '/../../spec_helper'
require_relative '../../../src/main/save_yahoo_quotes'

describe SaveYahooQuotes do

  describe "main" do
    describe "save_all_to_db" do
      xit "basic" do
        s = SaveYahooQuotes.new
        result = s.save_all_to_db

        expect(result).to eq(true)
      end
    end

    describe "save_to_db" do
      xit "AAPL" do
        s = SaveYahooQuotes.new
        base_dir = "/home/user/zzz/vmsync/data/.stock_scraper/csv/stock_quotes/"
        sym = "AAPL"
        filename = "AAPL.csv"

        result = s.save_to_db(sym, filename, base_dir)
        expect(result).to eq(true)
      end
    end
  end

  describe "main2" do
    describe "save_to_db" do
      it "GS1" do
        s = SaveYahooQuotes.new
        base_dir = Dir.pwd + "/test_data/main/stock_quotes/"
        sym = "GS`"
        filename = "GS_initial.csv"

        puts "aaaaa"
        puts Dir.pwd
        puts base_dir


        result = s.save_to_db(sym, filename, base_dir)
        expect(result).to eq(true)
      end
    end
  end

end
