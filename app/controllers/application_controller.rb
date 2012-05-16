class ApplicationController < ActionController::Base
	protect_from_forgery
  helper_method :current_user
  helper_method :authenticate_admin
  helper_method :authenticate_member
  helper_method :fetch_movie_src
  helper_method :admin?
  helper_method :member?

  private
  # ログインユーザーを返す
  def current_user
    @current_user ||= Omniuser.find(session[:user_id]) if session[:user_id]
  end

  # ログインユーザーが管理グループに属しているかどうかを返す
  def admin?
  	if current_user
  		return @current_user.belongs_to_admin_group?
  	else
  		return false
  	end
  	return false
  end

  # ログインユーザーがミューソグループに属しているかどうかを返す
  def member?
  	if current_user
  		return @current_user.belongs_to_member_group?
  	else
  		return false
  	end
  	return false
  end

  # 権限チェック
  def authenticate_member
    redirect_to root_url, :notice => "Required log in as Member." unless member?
  end

  def authenticate_admin
    redirect_to root_url, :notice => "Required log in as Admin." unless admin?
  end

  # AJAXのみ対応
  def check_ajax
    return redirect_to '/404.html' unless request.xhr?
  end

  def fetch_movie_src
    ###### feed更新時のpush通知に対応までの暫定対処(FeedFetch版)
    ###### 問題点１：index.html.erbロード時にfetchするので表示が遅くなる
    ###### 問題点２：feedの内容は一回ですべて取得できない(ページングがある)ので投稿だけすすんでだれもロードしなかった時更新が漏れる
    # source(ビデオのURL)が設定されてないオブジェクトを取得
    not_yet = Movie.find_all_by_source(nil)
    logger.debug "not_yet: #{not_yet}"
    # 空じゃなかったらFBに更新されているか探しにいく
    unless not_yet.blank?
      # HTTPSリクエスト用のオブジェクト用意
      require 'net/https'
      https = Net::HTTP.new("graph.facebook.com", 443)
      https.use_ssl = true
      # Herokuにあげる時はこれはいらないはず
      https.ca_file = "#{$RAILS_ROOT}/cacert.pem"
      https.verify_mode = OpenSSL::SSL::VERIFY_PEER
      https.verify_depth = 5
      # リクエスト開始
      https.start do |w|
        # Operation_M_testグループのfeedを取得
        response = w.get("/387659801250930/feed?fields=id,object_id,picture,source,properties&access_token=#{current_user.access_token}")
        logger.debug "resonse: #{response}"
        # feedから投稿完了時に返ってきたobject_idとひもづく投稿idを取得して対応をハッシュに保持
        feed = JSON.parse(response.body)
        logger.debug "feed: #{feed}"
        video_meta_id = Hash.new
        feed.each do |rk, rh|
          if rk == "data"
            rh.each do |item|
              if item.has_key?("object_id")
                video_meta_id[item["object_id"]] = item["id"]
              end
            end
          end
        end
        # development.logに対応表を出力
        logger.debug "video_meta_id: #{video_meta_id}"
        # sourceが設定されていないmovieオブジェクトにfeedからいろいろ設定していく
        not_yet.each do |movie|
          if video_meta_id.has_key?(movie.video)
            response = w.get("/#{video_meta_id[movie.video]}?access_token=#{current_user.access_token}")
            video_info = JSON.parse(response.body)
            logger.debug "#{movie.video}->meta: #{video_meta_id[movie.video]}"
            movie.meta = video_meta_id[movie.video]
            logger.debug "#{movie.video}->picture: #{video_info["picture"]}"
            movie.picture = video_info["picture"]
            # feedに入っているsourceだとHDじゃないのでwww.facebook.comドメインのembedで使われるurlを使う
            # logger.debug "#{movie.video}->source: #{video_info["source"]}"
            # movie.source = video_info["source"]
            logger.debug "#{movie.video}->source: http://www.facebook.com/v/#{movie.video}"
            movie.source = "http://www.facebook.com/v/#{movie.video}"
            # 動画の長さ以外に何が入るのかよくわかっていない
            logger.debug "#{movie.video}->length: #{video_info["properties"][0]["text"]}"
            movie.length = video_info["properties"][0]["text"]
            movie.save
          end
        end
      end
    end
  end
end
