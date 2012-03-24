class Concert < ActiveRecord::Base
  has_many :movies
end
