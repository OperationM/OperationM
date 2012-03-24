class Tag < ActiveRecord::Base
	has_many :taggings
	has_many :movies, :through => :taggings, :uniq => true

  def self.find_by_name_or_create(params)
    tag = self.find_by_name(params[:name]) || self.create(:name => params[:name])
    return tag
  end
end
