module MessageHelper
  def parse_json(json)
    JSON.parse(json, symbolize_names: true)
  end

  def success_message(message)
    { status: 200, message: message }.to_json
  end
end
