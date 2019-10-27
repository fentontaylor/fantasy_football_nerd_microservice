require_relative 'config/boot'

class App < Sinatra::Base
  include MessageHelper
  register Sinatra::Contrib

  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end

  get '/projections/:position/:week' do
    pos = params[:position]
    week = params[:week]
    response = FFNService.new('weekly-projections')
                         .fetch("/#{pos}/#{week}")
    response.body
  end

  get '/projections/update/:position/:week' do
    pos = params[:position]
    week = params[:week]

    service = FFNService.new('weekly-projections')
    projections = Projection.where(position: pos, week: week)

    if projections.empty?
      service.update_projections(pos, week)
      content_type :json
      success_message('Projections updated successfully.')
    else
      halt(
        409,
        { 'Content-Type' => 'json' },
        { status: 409, message: 'Those projection resources already exist.' }.to_json
      )
    end
  end

  get '/projections/update_all' do
    service = FFNService.new('weekly-projections')
    service.update_all_projections(params['max_week'])
  end

  get '/player_projections' do
    players = params['players']
    week = params['week']
    my_projections = Projection.my_projections(players, week)

    my_projections.map do |proj|
      { ffn_id: proj.playerId, projection: proj.calculate }
    end.to_json
  end

  get '/players' do
    sdio_response = Faraday.get(sdio_path('Players'))
    ffn_response = FFNService.new('players').fetch
    sdio_data = JSON.parse(sdio_response.body)
    ffn_data = JSON.parse(ffn_response.body)

    ffn_active = ffn_data['Players'].find_all { |player| player['active'] == '1' }

    s_players = sdio_data.map { |player_hash| SdioPlayer.new(player_hash) }

    name_counts = Hash.new(0)
    ffn_active.each { |player| name_counts[player['displayName']] += 1 }
    duplicates = name_counts.find_all { |name, count| count > 1 }.map(&:first)

    merged_data = ffn_active.map do |player|
      alt_name = player['displayName'].gsub('.', '')
      match =
        if duplicates.include? player['displayName']
          s_players.find do |plyr|
            (plyr.name == alt_name || plyr.alt_name == alt_name) && plyr.position == player['position']
          end
        else
          s_players.find { |plyr| plyr.name == alt_name || plyr.alt_name == alt_name }
        end

      match = SdioPlayer.new({}) if match.nil?
      player['experience'] = match.experience
      player['birthDate'] = match.birth_date
      player['photoUrl'] = match.photo_url
      player['byeWeek'] = match.bye_week
      player['ffn_id'] = player['playerId']
      player.delete('playerId')
      player.delete('dob')
      player
    end

    content_type :json
    merged_data.to_json
  end

  not_found do
    halt 404, { 'Content-Type' => 'json' }, { status: 404, message: 'Resource not found.' }.to_json
  end
end
