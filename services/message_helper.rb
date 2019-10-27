module MessageHelper
  def parse_json(json)
    JSON.parse(json, symbolize_names: true)
  end

  def success_message(message)
    { status: 200, message: message }.to_json
  end

  def error_404_message
    halt(
      404,
      { 'Content-Type' => 'json' },
      { status: 404, message: 'Resource not found.' }.to_json
    )
  end

  def invalid_key_message
    halt 403, { 'Content-Type' => 'json' }, { error: 'Invalid API key' }.to_json
  end

  def cannot_update_resource_message
    halt(
      409,
      { 'Content-Type' => 'json' },
      { status: 409, message: 'Those projection resources already exist.' }.to_json
    )
  end

  def update_all_template
    {
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
  end

  def sdio_path(path)
    "https://api.sportsdata.io/v3/nfl/scores/json/#{path}?key=#{ENV['SDIO_KEY']}"
  end
end
