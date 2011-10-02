class CreateUserSports < ActiveRecord::Migration
  def self.up
    create_table :user_sports do |t|
      t.integer :user_id, :null => false
      t.integer :sport_id, :null => false
      t.date :expiration_date

      t.timestamps
    end
    add_index :user_sports, :user_id
    add_index :user_sports, :sport_id
  end

  def self.down
    drop_table :user_sports
  end
end
