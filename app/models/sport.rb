class Sport < ActiveRecord::Base
  belongs_to :pick, :user_sport, :user_transaction_item
end
