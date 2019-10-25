class CreateProjections < ActiveRecord::Migration[5.2]
  def change
    create_table :projections do |t|
      t.integer :week
      t.integer :playerId
      t.string :position
      t.float :passAtt
      t.float :passCmp
      t.float :passYds
      t.float :passTD
      t.float :passInt
      t.float :rushAtt
      t.float :rushYds
      t.float :rushTD
      t.float :fumblesLost
      t.float :receptions
      t.float :recYds
      t.float :recTD
      t.float :fg
      t.float :fgAtt
      t.float :xp
      t.float :defInt
      t.float :defFR
      t.float :defFF
      t.float :defSack
      t.float :defTD
      t.float :defRetTD
      t.float :defSafety
      t.float :defPA
      t.float :defYdsAllowed
      t.string :displayName
      t.string :team

      t.timestamps
    end
  end
end
