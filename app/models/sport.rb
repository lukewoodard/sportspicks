class Sport < ActiveRecord::Base
  has_many :user_sports
  has_many :users, :through => :user_sports
end
