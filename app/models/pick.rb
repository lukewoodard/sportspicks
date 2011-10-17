class Pick < ActiveRecord::Base
  has_many :user_picks
  has_many :users, :through => :user_picks
  belongs_to :sport
end
