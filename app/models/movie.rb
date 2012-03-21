# encoding: utf-8
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
end
