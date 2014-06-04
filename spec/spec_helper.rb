require 'rubygems'
require 'bundler/setup'
#require 'ruby-debug'
require 'rspec'
#require 'capybara/rspec'
#require 'capybara-webkit'

# Capybara configuration
#Capybara.default_driver = :selenium
# Capybara.use_default_driver

# for screenshots if you need them.
#Capybara.save_and_open_page_path = File.dirname(__FILE__) + '/../snapshots'

# RSpec configuration
RSpec.configure do |config|

  config.before(:all) do
    # Create fixtures
  end

  config.after(:all) do
    # Destroy fixtures
  end

  # this loads all of the specs..
  config.around(:each) do |example|
    begin
      example.run
    rescue Exception => ex
      #save_and_open_page
      raise ex
    end
  end

end
