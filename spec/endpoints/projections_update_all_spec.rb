require 'spec_helper'

describe '/projections/update_all', type: :feature do
  it 'updates projections for all positions and weeks' do
    get '/projections/update_all?max_week=4'

    expect(last_response).to be_successful

    message = {
      status: 200,
      message: 'Projections updated successfully.',
      positions_updated: {
        QB:  { weeks: [1, 2, 3, 4] },
        RB:  { weeks: [1, 2, 3, 4] },
        WR:  { weeks: [1, 2, 3, 4] },
        TE:  { weeks: [1, 2, 3, 4] },
        K:   { weeks: [1, 2, 3, 4] },
        DEF: { weeks: [1, 2, 3, 4] }
      }
    }.to_json

    expect(last_response.body).to eq(message)
  end
end
