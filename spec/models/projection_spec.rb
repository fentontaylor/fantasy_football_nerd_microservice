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
      result = projection.calculate

      expect(result).to eq(12.74)
    end
  end
end
