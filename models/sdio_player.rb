class SdioPlayer
  attr_reader :birth_date,
              :bye_week,
              :dob,
              :experience,
              :name,
              :photo_url

  def initialize(hash)
    @birth_date = hash['BirthDateString']
    @bye_week = hash['ByeWeek']
    @dob = hash['BirthDate'].split('T').first
    @experience = hash['ExperienceString']
    @name = hash['Name']
    @photo_url = hash['PhotoUrl']
  end
end
