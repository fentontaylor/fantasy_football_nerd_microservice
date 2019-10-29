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

  def my_player_projections(players, week)
    week = week || Projection.maximum(:week)
    my_projections = Projection.my_projections(players, week)
    calculate_projections(my_projections, week)
  end

  def current_projections(max_week)
    max = max_week || 17
    update_all_projections(max)

    current_week = Projection.maximum(:week)
    most_recent = Projection.where(week: current_week)
                            .order(:playerId)
    calculate_projections(most_recent, current_week)
  end

  def current_injuries
    response = fetch('')
    data = parse_json(response.body)
    data[:Injuries].map { |k,v| v }
                   .flatten
                   .reject { |plyr| plyr[:playerId] == '0' }
                   .sort_by { |plyr| plyr[:playerId] }
                   .to_json
  end

  def calculate_projections(data, week)
    data.map do |proj|
      { 'week' => week.to_i, 'ffn_id' => proj.playerId, 'projection' => proj.calculate }
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
end
