class CreateKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :keys do |t|
      t.string :value
      t.integer :access_type, default: 0

      t.timestamps
    end
  end
end
