module MessageHelper
  def parse_json(json)
    JSON.parse(json, symbolize_names: true)
  end

  def success_message(message)
    { status: 200, message: message }.to_json
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
