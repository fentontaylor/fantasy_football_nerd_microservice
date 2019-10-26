class FFNService
  include MessageHelper

  def initialize(service)
    @service = service
  end

  def fetch(path)
    Faraday.get(root_url + path)
  end

  def create_projections(pos, week)
    response = fetch("/#{pos}/#{week}")
    data = parse_json(response.body)
    data[:Projections].each do |proj|
      Projection.create(proj)
    end
  end

  private

  def root_url
    'https://www.fantasyfootballnerd.com' \
      "/service/#{@service}/json/#{ENV['FF_NERD_KEY']}"
  end
end
