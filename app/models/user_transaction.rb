class UserTransaction < ActiveRecord::Base
  belongs_to :user
  has_many :user_transaction_items, :dependent => :destroy
end
