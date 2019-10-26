class SdioPlayer
  attr_reader :birth_date,
              :bye_week,
              :experience,
              :name,
              :photo_url,
              :position

  def initialize(hash)
    @birth_date = hash['BirthDateString']
    @bye_week = hash['ByeWeek']
    @experience = hash['ExperienceString']
    @name = hash['Name']
    @photo_url = hash['PhotoUrl']
    @position = hash['Position']
  end
end
