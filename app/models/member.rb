class Member < ActiveRecord::Base
  has_many :memberings
  has_many :movies, :through => :memberings
end
