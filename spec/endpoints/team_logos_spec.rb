require 'acceptance_helper'

describe '/team_logos', type: :feature do
  it 'should call sportsdata.io and return team_name with logo' do
    stub_team_logos
    key = create_admin_key

    get "/team_logos?key=#{key}"

    expect(last_response).to be_successful

    expected = {
      'team' => 'ARI',
      'team_logo' => 'https://upload.wikimedia.org/wikipedia/en/7/72/Arizona_Cardinals_logo.svg'
    }

    data = JSON.parse(last_response.body)
    expect(data.first).to eq(expected)
  end
end
