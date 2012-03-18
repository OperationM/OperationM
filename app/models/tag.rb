class Tag < ActiveRecord::Base
	has_many :taggings
	has_many :movies, :through => :taggings
end
