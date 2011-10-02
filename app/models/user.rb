class User < ActiveRecord::Base
  has_many :user_picks, :dependent => :destroy
  has_many :user_sports, :dependent => :destroy
  has_many :user_transactions, :dependent => :destroy
end
