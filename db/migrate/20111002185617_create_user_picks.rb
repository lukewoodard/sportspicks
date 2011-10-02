class CreateUserPicks < ActiveRecord::Migration
  def self.up
    create_table :user_picks do |t|
      t.integer :pick_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
    add_index :user_picks, :pick_id
    add_index :user_picks, :user_id
  end

  def self.down
    drop_table :user_picks
  end
end
