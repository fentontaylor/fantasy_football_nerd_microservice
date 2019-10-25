require_relative 'config/boot'

class App < Sinatra::Base
  register Sinatra::Contrib

  helpers do
    def ff_nerd_root
      'https://www.fantasyfootballnerd.com' \
        "/service/weekly-projections/json/#{ENV['FF_NERD_KEY']}"
    end

    def parse_json(json)
      JSON.parse(json, symbolize_names: true)
    end

    def success_message
      { status: 200, message: 'Projections updated successfully.' }.to_json
    end
  end

  get '/' do
    content_type :json
    { status: 200, message: 'No data at this endpoint.' }
  end

  get '/projections/:position/:week' do
    pos = params[:position]
    week = params[:week]
    response = Faraday.get(ff_nerd_root + "/#{pos}/#{week}")
    response.body
  end

  get '/projections/update/:position/:week' do
    pos = params[:position]
    week = params[:week]

    projections = Projection.where(position: pos, week: week)

    if projections.empty?
      response = Faraday.get(ff_nerd_root + "/#{pos}/#{week}")
      data = parse_json(response.body)
      data[:Projections].each do |proj|
        Projection.create(proj)
      end
      content_type :json
      success_message
    else
      halt 409, { 'Content-Type' => 'json' }, { status: 409, message: 'Those projection resources already exist.' }.to_json
    end
  end

  get '/projections/update_all' do
    positions = %w[QB RB WR TE K DEF]
    max = params['max_week'] || 17
    weeks = *(1..max.to_i)

    message = {
      status: 200,
      message: 'Projections updated successfully.',
      positions_updated: {
        QB:  { weeks: [] },
        RB:  { weeks: [] },
        WR:  { weeks: [] },
        TE:  { weeks: [] },
        K:   { weeks: [] },
        DEF: { weeks: [] }
      }
    }

    positions.each do |pos|
      weeks.each do |wk|
        response = Faraday.get(ff_nerd_root + "/#{pos}/#{wk}")
        data = JSON.parse(response.body, symbolize_names: true)

        break if data[:Projections].empty?

        projections = Projection.where(position: pos, week: wk)

        if projections.empty?
          data[:Projections].each { |proj| Projection.create(proj) }
          message[:positions_updated][pos.to_sym][:weeks] << wk
        end
      end
    end
    content_type :json
    message.to_json
  end

  get '/player_projections' do
    player_ids = params['players'].split('-')
    current_week = Projection.maximum(:week)
    my_projections = Projection.where(playerId: player_ids, week: current_week)

    message = {
      projections: []
    }

    my_projections.each do |proj|
      message[:projections] << { ffn_id: proj.playerId, projection: proj.calculate }
    end

    content_type :json
    message.to_json
  end

  not_found do
    halt 404, { 'Content-Type' => 'json' }, { status: 404, message: 'Resource not found.' }.to_json
  end
end
