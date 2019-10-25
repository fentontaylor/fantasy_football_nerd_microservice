require 'spec_helper'

def stub_projections(pos, week)
  json = File.open("./spec/fixtures/projections_#{pos.downcase}_#{week}.json")
  root_url = 'https://www.fantasyfootballnerd.com/service/weekly-projections/json/ffsqejxq4cax'
  stub_request(:get, "#{root_url}/#{pos.upcase}/#{week}")
    .to_return(status: 200, body: json)
end
