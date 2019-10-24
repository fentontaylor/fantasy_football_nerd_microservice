require_relative 'config/boot'

class App < Sinatra::Base
  register Sinatra::Contrib

  get '/' do
    content_type :json
    { status: 200, message: 'No data at this endpoint.' }
  end

  get '/projections/:position/:week' do
    pos = params[:position]
    week = params[:week]
    path = "/service/weekly-projections/json/#{ENV['FF_NERD_KEY']}/#{pos}/#{week}"
    response = Faraday.get('https://www.fantasyfootballnerd.com' + path)
    response.body
  end

  get '/projections/update/:position/:week' do
    pos = params[:position]
    week = params[:week]

    projections = Projection.where(position: pos, week: week)

    if projections.empty?
      path = "/service/weekly-projections/json/#{ENV['FF_NERD_KEY']}/#{pos}/#{week}"
      response = Faraday.get('https://www.fantasyfootballnerd.com' + path)
      data = JSON.parse(response.body, symbolize_names: true)
      data[:Projections].each do |proj|
        Projection.create(proj)
      end
      content_type :json
      { status: 200, message: 'Projections updated successfully.' }.to_json
    else
      halt 409, { 'Content-Type' => 'json' }, { status: 409, message: 'Those projection resources already exist.' }.to_json
    end
  end

  get '/projections/update_all' do
    positions = %w[QB RB WR TE K DEF]
    weeks = *(1..17)

    positions.each do |pos|
      weeks.each do |wk|
        path = "/service/weekly-projections/json/#{ENV['FF_NERD_KEY']}/#{pos}/#{wk}"
        response = Faraday.get('https://www.fantasyfootballnerd.com' + path)
        data = JSON.parse(response.body, symbolize_names: true)

        break if data[:Projections].empty?

        projections = Projection.where(position: pos, week: wk)

        data[:Projections].each { |proj| Projection.new(proj) } if projections.empty?
      end
    end
  end

  not_found do
    halt 404, { 'Content-Type' => 'json' }, { status: 404, message: 'Resource not found.' }.to_json
  end
end
