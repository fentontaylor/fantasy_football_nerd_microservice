require_relative 'config/boot'

class App < Sinatra::Base
  include MessageHelper
  include AuthorizationHelper
  register Sinatra::Contrib

  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end

  get '/projections/:position/:week' do
    if valid_open_key?(params[:key])
      pos = params[:position]
      week = params[:week]
      response = FFNService.new('weekly-projections')
                           .fetch("/#{pos}/#{week}")
      response.body
    else
      invalid_key_message
    end
  end

  get '/projections/update/:position/:week' do
    if valid_admin_key?(params[:key])
      pos = params[:position]
      week = params[:week]

      service = FFNService.new('weekly-projections')
      projections = Projection.where(position: pos, week: week)

      if projections.empty?
        service.update_projections(pos, week)
        content_type :json
        success_message('Projections updated successfully.')
      else
        cannot_update_resource_message
      end
    else
      invalid_key_message
    end
  end

  get '/projections/update_all' do
    if valid_admin_key?(params[:key])
      service = FFNService.new('weekly-projections')
      service.update_all_projections(params['max_week'])
    else
      invalid_key_message
    end
  end

  get '/player_projections' do
    if valid_admin_key?(params[:key])
      players = params['players']
      week = params['week']
      my_projections = Projection.my_projections(players, week)

      my_projections.map do |proj|
        { ffn_id: proj.playerId, projection: proj.calculate }
      end.to_json
    else
      invalid_key_message
    end
  end

  get '/players' do
    if valid_admin_key?(params[:key])
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
    else
      invalid_key_message
    end
  end

  not_found do
    error_404_message
  end
end
