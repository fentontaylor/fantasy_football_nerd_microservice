require 'acceptance_helper'

describe 'User sends a request to the API' do
  context 'they must provide a valid API key for open access endpoints' do
    before :each do
      stub_projections('WR', 1)
      @open_key = create_open_key
      @error_message = { error: 'Invalid API key' }.to_json
    end

    scenario 'it sends error message, status 403 if no key given' do
      get '/projections/WR/1'

      expect(last_response.body).to eq(@error_message)
    end

    scenario 'it sends error message, status 403 if no key is invalid' do
      get '/projections/WR/1?key=aaaaaaaa'

      expect(last_response.body).to eq(@error_message)
    end

    scenario 'it returns json, status 200 if key is valid' do
      get "/projections/WR/1?key=#{@open_key}"

      expect(last_response).to be_successful

      json = JSON.parse(last_response.body, symbolize_names: true)
      data = json[:Projections].first

      expect(data).to have_key(:week)
      expect(data).to have_key(:playerId)
      expect(data).to have_key(:position)
    end
  end

  context 'must provide valid admin API key for restricted endpoints' do
    before :each do
      stub_projections('WR', 1)
      @open_key = create_open_key
      @admin_key = create_admin_key
      @error_message = { error: 'Invalid API key' }.to_json
    end

    scenario 'it sends error message, status 403 if no key given' do
      get '/projections/update/WR/1'

      expect(last_response).to_not be_successful
      expect(last_response.body).to eq(@error_message)
    end

    scenario 'it sends error message, status 403 if no key is given but is wrong access_type' do
      get "/projections/update/WR/1?key=#{@open_key}"

      expect(last_response).to_not be_successful
      expect(last_response.body).to eq(@error_message)
    end

    scenario 'it updates records if key is valid and correct access_type' do
      get "/projections/update/WR/1?key=#{@admin_key}"

      expect(last_response).to be_successful
    end
  end
end
