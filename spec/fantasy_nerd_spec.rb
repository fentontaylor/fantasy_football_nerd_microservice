require_relative 'spec_helper'

describe 'fantasy nerd spec' do
  it 'should return projections for a position and week' do
    pos = 'QB'
    week = '4'
    path = "/service/weekly-projections/json/#{ENV['FF_NERD_KEY']}/#{pos}/#{week}"
    response = Faraday.get('https://www.fantasyfootballnerd.com' + path)

    json = JSON.parse(response.body, symbolize_names: true)
    data = json[:Projections].first
    
    expect(data).to have_key(:week)
    expect(data).to have_key(:playerId)
    expect(data).to have_key(:position)
    expect(data).to have_key(:passYds)
    expect(data).to have_key(:rushYds)
    expect(data).to have_key(:recYds)
  end
end
