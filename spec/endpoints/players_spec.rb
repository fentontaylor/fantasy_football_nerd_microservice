require 'acceptance_helper'

describe '/players', type: :feature do
  context 'by default (without ?inactive=true)' do
    it 'should return json of active players info' do
      WebMock.allow_net_connect!
      get '/players'

      expect(last_response).to be_successful

      first_result = {
        'ffn_id' => '2',
        'active' => '1',
        'jersey' => '3',
        'lname' => 'Anderson',
        'fname' => 'Derek',
        'displayName' => 'Derek Anderson',
        'team' => 'BUF',
        'position' => 'QB',
        'height' => '6-6',
        'weight' => '235',
        'college' => 'Oregon State',
        'experience' => '15th Season',
        'birthDate' => 'June 15, 1983',
        'photoUrl' => 'https =>//s3-us-west-2.amazonaws.com/static.fantasydata.com/headshots/nfl/low-res/12083.png',
        'byeWeek' => 'NA'
      }.to_json

      data = JSON.parse(last_response.body)

      expect(data['players'].first).to eq(first_result)
    end
  end
end
