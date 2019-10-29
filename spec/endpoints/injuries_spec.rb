require 'acceptance_helper'

describe '/injuries', type: :feature do
  it 'returns players who are currently injured, including the status' do
    WebMock.allow_net_connect!

    key = create_admin_key

    get "/injuries?key=#{key}"

    expect(last_response).to be_successful

    expected = {
      "week" => "8",
      "playerId" => "102",
      "playerName" => "Drew Stanton",
      "team" => "CLE",
      "position" => "QB",
      "injury" => "Knee",
      "practiceStatus" => "",
      "gameStatus" => "Ir. Injured Reserve",
      "notes" => "",
      "lastUpdate" => "2019-10-28",
      "practiceStatusId" => ""
    }

    data = JSON.parse(last_response.body)

    expect(data.first).to eq(expected)
  end
end