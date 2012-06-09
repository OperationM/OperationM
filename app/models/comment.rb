class Comment < ActiveRecord::Base
  belongs_to :omniuser
  belongs_to :movie

  attr_accessible :comment
  validates :movie_id, :presence => true
  validates :omniuser_id, :presence => true
  validates :comment, :presence => true

  default_scope :order => 'comments.created_at ASC'
end
