class Trackking < ActiveRecord::Base
  belongs_to :movie
  belongs_to :track
end
