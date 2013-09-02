require 'rubygems'
require 'mechanize'
require 'csv'

# a simple csv helper that pulls down a CSV from a website
# returns it in a easy to use fashion..
# probably an array of hashes.
class CsvHelper
  attr_accessor :web_url, :csv_params
  
  # csv params takes a hash...
  # each param is listed in the order.
  def initialize(params = {})
    
  end
  
end