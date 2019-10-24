require 'spec_helper'

describe 'visiting the endpoint /projections/update/:position/:week', type: :feature do
  it 'should update the database with those records if they do not exist' do
    get '/projections/update/QB/1'
    expect(last_response).to be_successful

    resp = '{"status":200,"message":"Projections updated successfully."}'
    expect(last_response.body).to eq(resp)

    get '/projections/update/QB/1'
    expect(last_response).to_not be_successful

    resp = '{"status":409,"message":"Those projection resources already exist."}'
    expect(last_response.body).to eq(resp)
  end
end
