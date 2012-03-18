class Movie < ActiveRecord::Base
	has_many :taggings
	has_many :tags, :through => :taggings
  has_many :memberings
  has_many :members, :through => :memberings
  has_many :trackkings
  has_many :tracks, :through => :trackkings
end
