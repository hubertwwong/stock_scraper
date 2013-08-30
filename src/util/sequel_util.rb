require 'mysql'

class SequelUtil
  
  attr_accessor :url, :user, :password, :db_name
  
  # need to pass all of the db args for the methods to work.
  def initialize(params = {})
    @url = params.fetch(:url)
    @user = params.fetch(:user)
    @password = params.fetch(:password)
    @db_name= params.fetch(:db_name)
    
    # connect to db.
    @db = Sequel.connect(:adapter => 'mysql', 
          :user => @user,
          :password=> @password, 
          :host => @url, 
          :database => @db_name)
  end
  
  # INSERT METHODS
  ############################################################################
  
  
  # READ METHODS
  ############################################################################
  
  
end