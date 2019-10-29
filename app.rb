require_relative 'config/boot'

class App < Sinatra::Base
  include MessageHelper
  include AuthorizationHelper
  register Sinatra::Contrib

  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end

  get '/projections/:position/:week' do
    return invalid_key_message unless valid_open_key?(params[:key])

    pos = params[:position]
    week = params[:week]
    response = FFNService.new('weekly-projections')
                         .fetch("/#{pos}/#{week}")
    content_type :json
    response.body
  end

  get '/projections/update/:position/:week' do
    return invalid_key_message unless valid_admin_key?(params[:key])

    pos = params[:position]
    week = params[:week]

    service = FFNService.new('weekly-projections')
    projections = Projection.where(position: pos, week: week)

    content_type :json

    if projections.empty?
      service.update_projections(pos, week)
      success_message('Projections updated successfully.')
    else
      cannot_update_resource_message
    end
  end

  get '/projections/update_all' do
    return invalid_key_message unless valid_admin_key?(params[:key])

    service = FFNService.new('weekly-projections')
    content_type :json
    service.update_all_projections(params[:max_week])
  end

  get '/projections/current' do
    return invalid_key_message unless valid_admin_key?(params[:key])

    service = FFNService.new('weekly-projections')
    content_type :json
    service.current_projections(params[:max_week])
  end

  get '/player_projections' do
    return invalid_key_message unless valid_admin_key?(params[:key])

    players = params['players']
    week = params['week']
    service = FFNService.new
    content_type :json
    service.my_player_projections(players, week)
  end

  get '/injuries' do
    return invalid_key_message unless valid_open_key?(params[:key])

    service = FFNService.new('injuries')
    content_type :json
    service.current_injuries
  end

  get '/players' do
    return invalid_key_message unless valid_admin_key?(params[:key])

    service = FFNService.new('players')
    content_type :json
    service.all_players
  end

  not_found do
    error_404_message
  end
end
