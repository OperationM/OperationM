class Member < ActiveRecord::Base
  has_many :memberings
  has_many :movies, :through => :memberings

  # FBのIDでユーザーを作成
  def self.create_with_id_and_name(id, name)
    create!do |member|
      member.id = id
      member.name = name
    end
  end
end
