class Projection < ActiveRecord::Base
  def calculate
    if position == 'K'
      kicker_score
    elsif position == 'DEF'
      defense_score
    else
      offense_score
    end
  end

  private

  def offense_score
    passYds * 0.04 +
      passTD * 4 +
      fumblesLost * -2 +
      passInt * -1 +
      rushYds * 0.1 +
      rushTD * 6 +
      recYds * 0.1 +
      recTD * 6
  end

  def kicker_score
    (fg * 3.2 + xp).to_f
  end

  def defense_score
    defTD * 6 +
      defFR * 2 +
      defInt * 2 +
      defSack * 1 +
      defSafety * 2 +
      points_allowed(defPA)
  end

  def points_allowed(pts_allowed)
    case pts_allowed
    when 0 then 10
    when 1..6 then 7
    when 7..13 then 4
    when 14..20 then 1
    when 21..27 then 0
    when 28..34 then -1
    when 35..150 then -4
    end
  end
end
