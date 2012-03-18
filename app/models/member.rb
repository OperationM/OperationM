class Member < ActiveRecord::Base
  has_many :memberings
  has_many :movies, :through => :memberings

  # FBのIDでユーザーを作成
  def self.create_with_id(id)
    create!do |member|
      member.id = id
    end
  end
end
