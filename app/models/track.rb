class Track < ActiveRecord::Base
  has_many :trackkings
  has_many :movies, :through => :trackkings, :uniq => true
  belongs_to :artist

  def self.find_by_name_or_create(params)
    track = self.find_by_name(params[:track]) || self.create(:name => params[:track], :art_work_url_30 => params[:artwork])
    artist = Artist.find_by_name_or_create(params)
    track.artist = artist
    track.save
    return track
  end
end
