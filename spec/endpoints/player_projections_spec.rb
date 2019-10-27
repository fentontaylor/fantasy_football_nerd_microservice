require 'acceptance_helper'

describe '/player_projections?players={list_of_ids}', type: :feature do
  before :each do
    @key = create_admin_key

    stub_projections('QB', 1)
    stub_projections('QB', 2)
    stub_projections('RB', 1)
    stub_projections('RB', 2)
    stub_projections('WR', 2)
    stub_projections('TE', 2)
    stub_projections('K', 2)
    stub_projections('DEF', 2)

    get "/projections/update/QB/1?key=#{@key}"
    get "/projections/update/QB/2?key=#{@key}"
    get "/projections/update/RB/1?key=#{@key}"
    get "/projections/update/RB/2?key=#{@key}"
    get "/projections/update/WR/2?key=#{@key}"
    get "/projections/update/TE/2?key=#{@key}"
    get "/projections/update/K/2?key=#{@key}"
    get "/projections/update/DEF/2?key=#{@key}"
  end

  scenario 'returns most recent player projections if no week is specified' do
    get "/player_projections?players=2812-3326-1446-2198-752-1041&key=#{@key}"

    expect(last_response).to be_successful

    result = [
      { ffn_id: 752, projection: 9.38 },
      { ffn_id: 1041, projection: 12.4 },
      { ffn_id: 1446, projection: 13.4 },
      { ffn_id: 2198, projection: 11.75 },
      { ffn_id: 2812, projection: 17.55 },
      { ffn_id: 3326, projection: 12.79 }
    ]

    data = JSON.parse(last_response.body, symbolize_names: true)

    expect(data).to eq(result)
  end

  scenario 'returns projections for a specified week if param given' do
    get "/player_projections?players=2812-3354&week=1&key=#{@key}"

    expect(last_response).to be_successful

    result = [
      { ffn_id: 2812, projection: 20.12 },
      { ffn_id: 3354, projection: 14.27 }
    ]

    data = JSON.parse(last_response.body, symbolize_names: true)

    expect(data).to eq(result)
  end
end
