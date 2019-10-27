require 'acceptance_helper'

describe '/projections/:position/:week', type: :feature do
  it 'should return projections for a position and week' do
    stub_projections('QB', 1)
    key = create_admin_key
    pos = 'QB'
    week = '1'
    get "/projections/#{pos}/#{week}?key=#{key}"

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
