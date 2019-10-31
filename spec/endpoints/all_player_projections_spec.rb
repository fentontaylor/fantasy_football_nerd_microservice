require 'acceptance_helper'

describe '/all_player_projections/:player_id' do
  before :each do
    @key = create_admin_key

    stub_projections('QB', 1)
    stub_projections('QB', 2)
    stub_projections('QB', 3)

    get "/projections/update/QB/1?key=#{@key}"
    get "/projections/update/QB/2?key=#{@key}"
    get "/projections/update/QB/3?key=#{@key}"
  end

  scenario 'returns all projections for a player' do
    get "/all_player_projections/13?key=#{@key}"

    expect(last_response).to be_successful

    result = [
      { 'week' => 1, 'ffn_id' => 13, 'projection' => 18.67 },
      { 'week' => 2, 'ffn_id' => 13, 'projection' => 21.05 },
      { 'week' => 3, 'ffn_id' => 13, 'projection' => 20.24 }
    ]

    data = JSON.parse(last_response.body)

    expect(data).to eq(result)
  end
end
