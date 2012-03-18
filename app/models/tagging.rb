class Tagging < ActiveRecord::Base
	belongs_to :movie
	belongs_to :tag
end
