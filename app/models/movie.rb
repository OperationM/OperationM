class Movie < ActiveRecord::Base
	has_many :taggings
	has_many :tags, :through => :taggings
  has_many :memberings
  has_many :members, :through => :memberings
  has_many :trackkings
  has_many :tracks, :through => :trackkings

  scope :movie, lambda { |term| where("title like ? or description like ?", "%#{term}%", "%#{term}%") unless term.blank? }
  scope :member, lambda{ |term| joins(:members).where("members.name like ?", "%#{term}%") unless term.blank? }
  scope :tag, lambda{ |term| joins(:tags).where("tags.name like ?", "%#{term}%") unless term.blank? }
  scope :track, lambda{ |term| joins(:tracks).where("tracks.name like ?", "%#{term}%") unless term.blank? }
  scope :artist, lambda{ |term| joins(:tracks => :artist).where("artists.name like ?", "%#{term}%") unless term.blank? }

  def self.search(term = nil, scopes = [:movie, :member, :tag, :track, :artist], unique = true)
    if unique
      return self.combined(term, scopes)
    else
      return self.indivisual(term, scopes)
    end
  end

  def self.combined(term, scopes)
    results = []
    unless term.blank?
      scopes.map do |scope|
        results |= self.send(scope,term)
      end
    end
    results
  end

  def self.indivisual(term, scopes)
    results = {}
    unless term.blank?
      scopes.map do |scope|
        results[scope] = self.send(scope,term)
      end
    end
    results
  end
end
