require 'spec_helper'
require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application

describe 'visiting the endpoint /projections/update/:position/:week' do
  it 'should update the database with those records if they do not exist' do
    visit '/projections/QB/3'
  end
end
