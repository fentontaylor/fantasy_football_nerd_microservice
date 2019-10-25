require 'acceptance_helper'

describe '/player_projections?players={list_of_ids}', type: :feature do
  it 'returns most recent player projections if no week is specified' do
    stub_projections('QB', 1)
    stub_projections('QB', 2)
    stub_projections('RB', 1)
    stub_projections('RB', 2)
    stub_projections('WR', 2)
    stub_projections('TE', 2)
    stub_projections('K', 2)
    stub_projections('DEF', 2)

    get '/projections/update/QB/1'
    get '/projections/update/QB/2'
    get '/projections/update/RB/1'
    get '/projections/update/RB/2'
    get '/projections/update/WR/2'
    get '/projections/update/TE/2'
    get '/projections/update/K/2'
    get '/projections/update/DEF/2'

    get '/player_projections?players=2812-3326-1446-2198-752-1041'

    result = {
      projections: [
        { ffn_id: 752, projection: 0 },
        { ffn_id: 1041, projection: 0 },
        { ffn_id: 1446, projection: 0 },
        { ffn_id: 2198, projection: 0 },
        { ffn_id: 2812, projection: 0 },
        { ffn_id: 3326, projection: 0 }
      ]
    }.to_json

    expect(last_response.body).to eq(result)
  end
end
