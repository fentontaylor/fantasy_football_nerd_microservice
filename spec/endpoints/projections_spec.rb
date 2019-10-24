require 'spec_helper'

describe '/projections/:position/:week', type: :feature do
  it 'should return projections for a position and week' do
    pos = 'QB'
    week = '4'
    get "/projections/#{pos}/#{week}"

    expect(last_response).to be_successful

    json = JSON.parse(last_response.body, symbolize_names: true)
    data = json[:Projections].first

    expect(data).to have_key(:week)
    expect(data).to have_key(:playerId)
    expect(data).to have_key(:position)
    expect(data).to have_key(:passYds)
    expect(data).to have_key(:rushYds)
    expect(data).to have_key(:recYds)
  end
end
