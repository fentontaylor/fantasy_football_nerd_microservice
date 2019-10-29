class SDIOService
  include MessageHelper

  def initialize(service)
    @service = service
  end

  def team_logos
    response = Faraday.get(sdio_path(@service))
    data = parse_json(response.body)

    extract_logos(data).to_json
  end

  private

  def extract_logos(data)
    data.map do |team|
      {
        team: team[:Key],
        team_logo: team[:WikipediaLogoUrl],
        city: team[:City],
        name: team[:Name]
      }
    end
  end
end
