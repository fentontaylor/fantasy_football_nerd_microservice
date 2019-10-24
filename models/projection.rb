class Projection < ActiveRecord::Base
  def calculate
    if position == 'K'
    elsif position == 'DEF'
    else
      offense_score
    end
  end

  def offense_score
    (passYds * 0.04) +
      (passTD * 4) +
      (fumblesLost * -2) +
      (passInt * -1) +
      (rushYds * 0.1) +
      (rushTD * 6) +
      (recYds * 0.1) +
      (recTD * 6)
  end
end
