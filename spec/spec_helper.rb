ENV['RACK_ENV'] = 'test'
abort('DATABASE_URL environment variable is set') if ENV['DATABASE_URL']

require_relative '../app'
require 'capybara/rspec'
require 'bundler'

Bundler.require(:default, :test)

require File.expand_path('../../config/environment.rb', __FILE__)

DatabaseCleaner.strategy = :truncation

module SinatraApp
  def app
    App
  end
end

Capybara.app = SinatraApp

RSpec.configure do |config|
  config.before(:all) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'tmp/rspec_examples.txt'
  config.order = :random

  config.include Rack::Test::Methods
  config.include SinatraApp
  config.include Capybara::DSL
end

ActiveRecord::Migration.maintain_test_schema!
