class CreateUserTransactionItems < ActiveRecord::Migration
  def self.up
    create_table :user_transaction_items do |t|
      t.integer :sport_id
      t.integer :user_transaction_id, :null => false
      t.integer :weeks

      t.timestamps
    end
    add_index :user_transaction_items, :sport_id
    add_index :user_transaction_items, :user_transaction_id
  end

  def self.down
    drop_table :user_transaction_items
  end
end
