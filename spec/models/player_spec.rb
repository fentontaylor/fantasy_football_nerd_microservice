require 'acceptance_helper'

describe Player do
  before :each do
    @ffn_hash = {
      "playerId" => "87",
      "active" => "1",
      "jersey" => "12",
      "lname" => "Rodgers",
      "fname" => "Aaron",
      "displayName" => "Aaron Rodgers",
      "team" => "GB",
      "position" => "QB",
      "height" => "6-2",
      "weight" => "225",
      "dob" => "1983-12-02",
      "college" => "California"
    }

    @sd_hash =     {
      "PlayerID" => 2593,
      "Team" => "GB",
      "Number" => 12,
      "FirstName" => "Aaron",
      "LastName" => "Rodgers",
      "Position" => "QB",
      "Status" => "Active",
      "Height" => "6'2\"",
      "Weight" => 225,
      "BirthDate" => "1983-12-02T00 =>00 =>00",
      "College" => "California",
      "Experience" => 17,
      "FantasyPosition" => "QB",
      "Active" => true,
      "PositionCategory" => "OFF",
      "Name" => "Aaron Rodgers",
      "Age" => 35,
      "ExperienceString" => "15th Season",
      "BirthDateString" => "December 2, 1983",
      "PhotoUrl" => "https =>//s3-us-west-2.amazonaws.com/static.fantasydata.com/headshots/nfl/low-res/2593.png",
      "ByeWeek" => 11,
    }

    @ffn_hash['experience'] = @sd_hash['ExperienceString']
    @ffn_hash['birthDate'] = @sd_hash['BirthDateString']
    @ffn_hash['photoUrl'] = @sd_hash['PhotoUrl']
    @ffn_hash['byeWeek'] = @sd_hash['ByeWeek']
  end

  it 'can initialize with a hash' do
    player = Player.new(@ffn_hash)
    expect(player).to be_an_instance_of Player
  end
end
