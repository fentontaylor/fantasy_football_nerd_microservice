require 'spec_helper'

describe 'visiting the endpoint /projections/update/:position/:week', type: :feature do
  it 'should update the database with those records if they do not exist' do
    Projection.destroy_all

    visit '/projections/update/QB/1'
    message = '{ "message": "Projections updated successfully." }'
    expect(page).to have_content(message)
  end
end
