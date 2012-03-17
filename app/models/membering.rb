class Membering < ActiveRecord::Base
  belongs_to :movie
  belongs_to :member
end
