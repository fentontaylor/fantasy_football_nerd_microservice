require_relative 'config/boot'

class App < Sinatra::Base
  register Sinatra::Contrib

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
      { status: 201, message: 'Projections updated successfully' }.to_json
    else
      { status: 409, message: 'Those projection resources already exist.' }.to_json
    end
  end

  not_found do
    content_type :json
    { status: 404, message: 'Resource not found.' }.to_json
  end
end
