class Artist < ActiveRecord::Base
  has_many :tracks

  # iTunesのIDで作成
  def self.create_with_id(id)
    create!do |artist|
      artist.id = id
    end
  end
end
