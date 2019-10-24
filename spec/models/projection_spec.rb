require 'spec_helper'

describe Projection do
  it 'can initialize with a hash' do
    hash = {
      week: '7',
      playerId: '1446',
      position: 'WR',
      passAtt: '0.0',
      passCmp: '0.0',
      passYds: '0.0',
      passTD: '0.0',
      passInt: '0.0',
      rushAtt: '0.1',
      rushYds: '0.4',
      rushTD: '0.0',
      fumblesLost: '0.0',
      receptions: '6.3',
      recYds: '91.0',
      recTD: '0.6',
      fg: '0.0',
      fgAtt: '0.0',
      xp: '0.0',
      defInt: '0.0',
      defFR: '0.0',
      defFF: '0.0',
      defSack: '0.0',
      defTD: '0.0',
      defRetTD: '0.0',
      defSafety: '0.0',
      defPA: '0.0',
      defYdsAllowed: '0.0',
      displayName: 'Julio Jones',
      team: 'ATL'
    }

    projection = Projection.create(hash)

    expect(projection).to be_an_instance_of Projection
  end

  describe 'instance_methods' do
    it '#calculate' do
      wr = {
        week: '7',
        playerId: '1446',
        position: 'WR',
        passAtt: '0.0',
        passCmp: '0.0',
        passYds: '0.0',
        passTD: '0.0',
        passInt: '0.0',
        rushAtt: '0.1',
        rushYds: '0.4',
        rushTD: '0.0',
        fumblesLost: '0.0',
        receptions: '6.3',
        recYds: '91.0',
        recTD: '0.6',
        fg: '0.0',
        fgAtt: '0.0',
        xp: '0.0',
        defInt: '0.0',
        defFR: '0.0',
        defFF: '0.0',
        defSack: '0.0',
        defTD: '0.0',
        defRetTD: '0.0',
        defSafety: '0.0',
        defPA: '0.0',
        defYdsAllowed: '0.0',
        displayName: 'Julio Jones',
        team: 'ATL'
      }

      qb = {
        week: '7',
        playerId: '1446',
        position: 'QB',
        passAtt: '30.0',
        passCmp: '22.0',
        passYds: '295.0',
        passTD: '2.4',
        passInt: '0.4',
        rushAtt: '3.2',
        rushYds: '8.3',
        rushTD: '0.0',
        fumblesLost: '0.0',
        receptions: '0.0',
        recYds: '0.0',
        recTD: '0.0',
        fg: '0.0',
        fgAtt: '0.0',
        xp: '0.0',
        defInt: '0.0',
        defFR: '0.0',
        defFF: '0.0',
        defSack: '0.0',
        defTD: '0.0',
        defRetTD: '0.0',
        defSafety: '0.0',
        defPA: '0.0',
        defYdsAllowed: '0.0',
        displayName: 'Thrower McGee',
        team: 'ATL'
      }

      defense = {
        week: "1",
        playerId: "1043",
        position: "DEF",
        passAtt: "0.0",
        passCmp: "0.0",
        passYds: "0.0",
        passTD: "0.0",
        passInt: "0.0",
        rushAtt: "0.0",
        rushYds: "0.0",
        rushTD: "0.0",
        fumblesLost: "0.0",
        receptions: "0.0",
        recYds: "0.0",
        recTD: "0.0",
        fg: "0.0",
        fgAtt: "0.0",
        xp: "0.0",
        defInt: "1.0",
        defFR: "0.7",
        defFF: "0.6",
        defSack: "3.2",
        defTD: "0.3",
        defRetTD: "0.0",
        defSafety: "0.0",
        defPA: "17.4",
        defYdsAllowed: "309.5",
        displayName: "Philadelphia Eagles",
        team: "PHI"
      }

      kicker = {
        week: "1",
        playerId: "1865",
        position: "K",
        passAtt: "0.0",
        passCmp: "0.0",
        passYds: "0.0",
        passTD: "0.0",
        passInt: "0.0",
        rushAtt: "0.0",
        rushYds: "0.0",
        rushTD: "0.0",
        fumblesLost: "0.0",
        receptions: "0.0",
        recYds: "0.0",
        recTD: "0.0",
        fg: "1.9",
        fgAtt: "1.9",
        xp: "2.7",
        defInt: "0.0",
        defFR: "0.0",
        defFF: "0.0",
        defSack: "0.0",
        defTD: "0.0",
        defRetTD: "0.0",
        defSafety: "0.0",
        defPA: "0.0",
        defYdsAllowed: "0.0",
        displayName: "Greg Zuerlein",
        team: "LAR"
      }

      wr_projection = Projection.create(wr)
      qb_projection = Projection.create(qb)
      defense_projection = Projection.create(defense)
      kicker_projection = Projection.create(kicker)

      wr_result = wr_projection.calculate
      expect(wr_result).to eq(12.74)

      qb_result = qb_projection.calculate
      expect(qb_result).to eq(21.83)

      defense_result = defense_projection.calculate
      expect(defense_result).to eq(9.4)

      kicker_result = kicker_projection.calculate
      expect(kicker_result).to eq(8.78)
    end
  end
end
