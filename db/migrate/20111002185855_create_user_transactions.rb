class CreateUserTransactions < ActiveRecord::Migration
  def self.up
    create_table :user_transactions do |t|
      t.integer :user_id, :null => false
      t.float :total
      t.string :discount_code
      t.date :transaction_date

      t.timestamps
    end
    add_index :user_transactions, :user_id
  end

  def self.down
    drop_table :user_transactions
  end
end
