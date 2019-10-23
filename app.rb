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

  not_found do
    content_type :json
    { status: 404, message: 'Resource not found.' }.to_json
  end
end
