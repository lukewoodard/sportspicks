class Sport < ActiveRecord::Base
  belongs_to :pick
  belongs_to :user_sport
  belongs_to :user_transaction_item
  
  attr_accessible :name, :description
end
