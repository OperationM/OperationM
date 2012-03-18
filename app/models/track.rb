class Track < ActiveRecord::Base
  has_many :trackkings
  has_many :movies, :through => :trackkings
  belongs_to :artist

  # iTunesのIDで作成
  def self.create_with_id(id)
    create!do |track|
      track.id = id
    end
  end
end
