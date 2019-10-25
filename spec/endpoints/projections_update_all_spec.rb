require 'acceptance_helper'

describe '/projections/update_all', type: :feature do
  it 'updates projections for all positions and weeks' do
    stub_all_projections_weeks_1_to_3

    get '/projections/update_all?max_week=3'

    expect(last_response).to be_successful

    message = {
      status: 200,
      message: 'Projections updated successfully.',
      positions_updated: {
        QB:  { weeks: [1, 2, 3] },
        RB:  { weeks: [1, 2, 3] },
        WR:  { weeks: [1, 2, 3] },
        TE:  { weeks: [1, 2, 3] },
        K:   { weeks: [1, 2, 3] },
        DEF: { weeks: [1, 2, 3] }
      }
    }.to_json

    expect(last_response.body).to eq(message)
  end

  it 'only updates projections that do not exist in db yet' do
    stub_all_projections_weeks_1_to_3

    get '/projections/update/QB/1'
    get '/projections/update/QB/2'
    get '/projections/update/RB/1'

    get '/projections/update_all?max_week=3'

    expect(last_response).to be_successful

    message = {
      status: 200,
      message: 'Projections updated successfully.',
      positions_updated: {
        QB:  { weeks: [3] },
        RB:  { weeks: [2, 3] },
        WR:  { weeks: [1, 2, 3] },
        TE:  { weeks: [1, 2, 3] },
        K:   { weeks: [1, 2, 3] },
        DEF: { weeks: [1, 2, 3] }
      }
    }.to_json

    expect(last_response.body).to eq(message)
  end
end
