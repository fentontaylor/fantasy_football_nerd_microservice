class CreateProjections < ActiveRecord::Migration[5.2]
  def change
    create_table :projections do |t|
      t.integer :week
      t.integer :playerId
      t.string :position
      t.decimal :passAtt
      t.decimal :passCmp
      t.decimal :passYds
      t.decimal :passTD
      t.decimal :passInt
      t.decimal :rushAtt
      t.decimal :rushYds
      t.decimal :rushTD
      t.decimal :fumblesLost
      t.decimal :receptions
      t.decimal :recYds
      t.decimal :recTD
      t.decimal :fg
      t.decimal :fgAtt
      t.decimal :xp
      t.decimal :defInt
      t.decimal :defFR
      t.decimal :defFF
      t.decimal :defSack
      t.decimal :defTD
      t.decimal :defRetTD
      t.decimal :defSafety
      t.decimal :defPA
      t.decimal :defYdsAllowed
      t.string :displayName
      t.string :team
    end
  end
end
