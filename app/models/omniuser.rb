class Omniuser < ActiveRecord::Base
	# 新たにユーザー情報を保持
	def self.create_with_omniauth(auth)
    create!do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.screen_name = auth["info"]["nickname"]
      user.access_token = auth["credentials"]["token"]
      user.admin = admin_group(auth)
      user.member = member_group(auth)
    end
  end

  # ログイン毎に権限情報を更新
  def self.update_with_omniauth(auth)
  	user = Omniuser.find_by_provider_and_uid(auth["provider"], auth["uid"])
  	if user
  		user.admin = admin_group(auth)
  		user.member = member_group(auth)
  		user.save
  	end
  	return user
  end

  # DBに保持しているユーザー情報から管理グループに属しているかをbooleanで返す
  def belongs_to_admin_group?
  	self.admin
  end

  # DBに保持しているユーザー情報からミューソグループに属しているかをbooleanで返す
  def belongs_to_member_group?
  	self.member
  end

  # 管理グループに属しているかチェック
  def self.admin_group(auth)
  	groups(auth).each do |h|
  		if h.has_value?("387659801250930")
  			return true
  		end
  	end
  	false
  end

  # ミューソグループに属しているかチェック
  def self.member_group(auth)
  	groups(auth).each do |h|
  		if h.has_value?("224428787635384")
  			return true
  		end
  	end
  	false
  end

  # ユーザーが属しているグループリストをHashで返却
  def self.groups(auth)
  	# HTTPSリクエスト用のオブジェクト用意
    require 'net/https'
    https = Net::HTTP.new("graph.facebook.com", 443)
    https.use_ssl = true
    # Herokuにあげる時はこれはいらないはず
    https.ca_file = "#{$RAILS_ROOT}/cacert.pem"
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5
    # リクエスト開始
    g = {}
    https.start do |w|
    	response = w.get("/#{auth['uid']}/groups&access_token=#{auth['credentials']['token']}")
      logger.debug "resonse: #{response}"
      g = JSON.parse(response.body)
	  end
	  g['data']
  end
end
