require 'acceptance_helper'

describe '/projections/current', type: :feature do
  before :each do
    @key = create_admin_key
    stub_all_projections_weeks_1_to_3
  end

  it 'makes sure the projections are updated and returns the most recent week' do
    get "/projections/current?key=#{@key}&max_week=3"

    expect(last_response).to be_successful

    first_element = {
      ffn_id: 13,
      projection: 20.24
    }

    data = JSON.parse(last_response.body, symbolize_names: true)

    expect(data.first).to eq(first_element)
  end
end
