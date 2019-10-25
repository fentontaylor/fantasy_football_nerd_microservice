require 'spec_helper'

describe '/player_projections?players={list_of_ids}', type: :feature do
  it 'returns most recent player projections if no week is specified' do
    Projection.create(position: 'QB', week: 1, playerId: 1)
    Projection.create(position: 'QB', week: 1, playerId: 2)
    Projection.create(position: 'RB', week: 1, playerId: 3)
    Projection.create(position: 'RB', week: 1, playerId: 4)

    Projection.create(position: 'QB', week: 2, playerId: 1)
    Projection.create(position: 'QB', week: 2, playerId: 2)
    Projection.create(position: 'RB', week: 2, playerId: 3)
    Projection.create(position: 'RB', week: 2, playerId: 4)

    get '/player_projections?players=1-2-4'

  end
end
