class SdioPlayer
  attr_reader :birth_date,
              :bye_week,
              :experience,
              :name,
              :photo_url,
              :position,
              :alt_name

  def initialize(hash)
    @birth_date = hash['BirthDateString']
    @bye_week = hash['ByeWeek']
    @experience = hash['ExperienceString']
    @name = hash['YahooName'] ? hash['YahooName'].gsub('.', '').downcase : nil
    @alt_name = hash['Name'] ? hash['Name'].gsub('.', '').downcase : nil
    @photo_url = hash['PhotoUrl']
    @position = hash['Position']
  end
end
