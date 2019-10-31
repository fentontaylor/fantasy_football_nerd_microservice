class FFNService
  include MessageHelper

  def initialize(service = nil)
    @service = service
  end

  def fetch(path = '')
    Faraday.get(root_url + path)
  end

  def update_projections(pos, week)
    response = fetch "/#{pos}/#{week}"
    data = parse_json response.body
    create_projections data[:Projections]
  end

  def update_all_projections(max_week)
    positions = %w[QB RB WR TE K DEF]
    max = max_week || 17
    weeks = *(1..max.to_i)

    message = update_all_template

    positions.each do |pos|
      weeks.each do |wk|
        response = fetch("/#{pos}/#{wk}")
        data = parse_json(response.body)[:Projections]

        break if data.empty?

        projections = Projection.where(position: pos, week: wk)

        if projections.empty?
          create_projections data
          message[:positions_updated][pos.to_sym][:weeks] << wk
        end
      end
    end
    message.to_json
  end

  def all_players
    s_players = sdio_data.map { |player_hash| SdioPlayer.new(player_hash) }

    merged_data = ffn_active_players.map do |player|
      match = find_match(player, s_players, ffn_active_players) || SdioPlayer.new({})

      player['experience'] = match.experience
      player['birthDate'] = match.birth_date
      player['photoUrl'] = match.photo_url
      player['byeWeek'] = match.bye_week
      player['ffn_id'] = player['playerId']
      player.delete('playerId')
      player.delete('dob')
      player
    end
    merged_data.to_json
  end

  def my_player_projections(players, week)
    week = week || Projection.maximum(:week)
    my_projections = Projection.my_projections(players, week)
    calculate_projections(my_projections)
  end

  def all_player_projections(id)
    data = Projection.where(playerId: id)
    calculate_projections(data)
  end

  def current_projections(max_week)
    max = max_week || 17
    update_all_projections(max)

    current_week = Projection.maximum(:week)
    most_recent = Projection.where(week: current_week)
                            .order(:playerId)
    calculate_projections(most_recent)
  end

  def current_injuries(week = nil)
    week = "/#{week}" || ''
    response = fetch(week)
    data = parse_json(response.body)
    data[:Injuries].map { |k,v| v }
                   .flatten
                   .reject { |plyr| plyr[:playerId] == '0' }
                   .sort_by { |plyr| plyr[:playerId].to_i }
                   .to_json
  end

  def calculate_projections(data)
    data.map do |proj|
       { 'week' => proj.week, 'ffn_id' => proj.playerId, 'projection' => proj.calculate }
    end.to_json
  end

  private

  def root_url
    'https://www.fantasyfootballnerd.com' \
      "/service/#{@service}/json/#{ENV['FF_NERD_KEY']}"
  end

  def create_projections(data)
    data.each { |proj| Projection.create(proj) }
  end

  def sdio_data
    data = Faraday.get(sdio_path('Players')).body
    parse_json(data, false)
  end

  def ffn_active_players
    return @ffn_active_players if @ffn_active_players

    ffn_data = JSON.parse(fetch.body)
    @ffn_active_players = ffn_data['Players'].find_all { |player| player['active'] == '1' }
  end

  def duplicate_names(data)
    return @duplicate_names if @duplicate_names

    name_counts = Hash.new(0)
    data.each { |player| name_counts[player['displayName']] += 1 }
    @duplicate_names = name_counts.find_all { |name, count| count > 1 }.map(&:first)
  end

  def find_match(player, objects, hash)
    alt_name = player['displayName'].gsub('.', '').downcase

    if duplicate_names(hash).include? player['displayName']
      objects.find do |plyr|
        (plyr.name == alt_name || plyr.alt_name == alt_name) && plyr.position == player['position']
      end
    else
      objects.find { |plyr| plyr.name == alt_name || plyr.alt_name == alt_name }
    end
  end
end
