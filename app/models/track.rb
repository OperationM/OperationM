class Track < ActiveRecord::Base
  has_many :trackkings
  has_many :movies, :through => :trackkings
  belongs_to :artist
end
