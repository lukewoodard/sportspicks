class UserPick < ActiveRecord::Base
  belongs_to :user
  belongs_to :pick
end
