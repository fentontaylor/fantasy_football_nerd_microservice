class Player
  def initialize(hash)
    @ffn_id = hash['playerId']
    @active = hash['active']
    @jersey = hash['jersey']
    @lname = hash['lname']
    @fname = hash['fname']
    @displayName = hash['displayName']
    @team = hash['team']
    @position = hash['position']
    @height = hash['height']
    @weight = hash['weight']
    @college = hash['college']
    @experience = hash['experience']
    @birthDate = hash['birthDate']
    @photoUrl = hash['photoUrl']
    @byeWeek = hash['byeWeek']
  end
end
