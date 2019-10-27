require 'spec_helper'

def ff_nerd_root(type)
  'https://www.fantasyfootballnerd.com' \
    "/service/#{type}/json/#{ENV['FF_NERD_KEY']}"
end

def sdio_path
  "https://api.sportsdata.io/v3/nfl/scores/json/Players?key=#{ENV['SDIO_KEY']}"
end

def stub_projections(pos, week)
  json = File.open("./spec/fixtures/projections_#{pos.downcase}_#{week}.json")
  root_url = ff_nerd_root('weekly-projections')
  stub_request(:get, "#{root_url}/#{pos.upcase}/#{week}")
    .to_return(status: 200, body: json)
end

def stub_all_projections_weeks_1_to_3
  positions = %w[QB RB WR TE K DEF]
  weeks = [1, 2, 3]

  positions.each do |pos|
    weeks.each do |week|
      stub_projections(pos, week)
    end
  end
end

def stub_ffn_players
  ffn_players = File.open('./spec/fixtures/ffn_players.json')
  stub_request(:get, ff_nerd_root('players'))
    .to_return(status: 200, body: ffn_players)
end

def stub_sdio_players
  sdio_players = File.open('./spec/fixtures/sd_players.json')
  stub_request(:get, sdio_path)
    .to_return(status: 200, body: sdio_players)
end

def create_admin_key
  admin_key = Digest::MD5.hexdigest 'admin_test'
  register_key(admin_key, 1)
  admin_key
end

def create_open_key
  open_key = Digest::MD5.hexdigest 'open_test'
  register_key(open_key, 0)
  open_key
end

def register_key(key, access_type)
  key_digest = Digest::MD5.hexdigest key
  Key.create(value: key_digest, access_type: access_type)
end
