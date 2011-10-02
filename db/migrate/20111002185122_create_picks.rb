class CreatePicks < ActiveRecord::Migration
  def self.up
    create_table :picks do |t|
      t.integer :sport_id, :null => false
      t.date :game_date
      t.string :description
      t.string :pick
      t.boolean :iswinner
      t.boolean :ispush
      t.boolean :play

      t.timestamps
    end
    add_index :picks, :sport_id
  end

  def self.down
    drop_table :picks
  end
end
