class Artist < ActiveRecord::Base
  has_many :tracks

  def self.find_by_name_or_create(params)
    artist = self.find_by_name(params[:artist]) || self.create(:name => params[:artist])
  end
end
