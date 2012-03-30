# encoding: utf-8
class Movie < ActiveRecord::Base
	has_many :taggings
	has_many :tags, :through => :taggings, :uniq => true
  has_many :memberings
  has_many :members, :through => :memberings, :uniq => true
  has_many :trackkings
  has_many :tracks, :through => :trackkings, :uniq => true
  belongs_to :band
  belongs_to :concert

  scope :member, lambda{ |term| joins(:members).where("members.name like ?", "%#{term}%") unless term.blank? }
  scope :tag, lambda{ |term| joins(:tags).where("tags.name like ?", "%#{term}%") unless term.blank? }
  scope :track, lambda{ |term| joins(:tracks).where("tracks.name like ?", "%#{term}%") unless term.blank? }
  scope :artist, lambda{ |term| joins(:tracks => :artist).where("artists.name like ?", "%#{term}%") unless term.blank? }
  scope :concert, lambda { |term| joins(:concert).where("concerts.name like ?", "%#{term}%") unless term.blank? }
  scope :band, lambda { |term| joins(:band).where("bands.name like ?", "%#{term}%") unless term.blank? }

  def self.search(term = nil, scopes = [:member, :tag, :track, :artist, :concert, :band], unique = true)
    words = Array.new
    words = term.gsub(/　/," ").split(nil)
    if unique
      return self.combined(words, scopes)
    else
      return self.indivisual(words, scopes)
    end
  end

  def self.combined(words, scopes)
    results = []
    words.each do |word|
      unless word.blank?
        scopes.map do |scope|
          results |= self.send(scope,word)
        end
      end
    end
    results
  end

  def self.indivisual(term, scopes)
    results = {}
    words.each do |word|
      unless word.blank?
        scopes.map do |scope|
          results[scope] << self.send(scope,word)
        end
      end
    end
    results
  end

  def update_concert_and_band(params)
    if params[:movie][:concert][:id] == "New"
      self.create_concert(:name => params[:movie][:concert][:name])
    else
      self.concert = Concert.find(params[:movie][:concert][:id])
    end

    if params[:movie][:band][:id] == "New"
      self.create_band(:name => params[:movie][:band][:name])
    else
      self.band = Band.find(params[:movie][:band][:id])
    end
    return self
  end
end
