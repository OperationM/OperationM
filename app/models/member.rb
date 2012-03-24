class Member < ActiveRecord::Base
  has_many :memberings
  has_many :movies, :through => :memberings

  def self.find_by_name_or_create(params)
    member = self.find_by_name(params[:name]) || self.create(:name => params[:name])
    return member
  end
end
