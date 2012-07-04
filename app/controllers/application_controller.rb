class ApplicationController < ActionController::Base
	protect_from_forgery
  helper_method :current_user
  helper_method :authenticate_admin
  helper_method :authenticate_member
  helper_method :fetch_movie_src
  helper_method :admin?
  helper_method :member?
  helper_method :hq_src
  helper_method :sec2strtime

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

  def https_get(domain,path,params)
    require 'net/http'
    require 'net/https'
    https = Net::HTTP.new("graph.facebook.com", 443)
    https.use_ssl = true
    https.ca_file = "#{$RAILS_ROOT}/cacert.pem"
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https.verify_depth = 5

    path = unless params.empty?
      path + "?" + params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
    else
      path
    end
    resp, data = https.get(path, params)
  end

  def get_movie_info(video_id)
    params = {
      "q" => "SELECT length, src_hq, src, vid, thumbnail_link, updated_time, created_time FROM video WHERE vid= #{video_id}",
      "format" => 'json',
      "access_token" => "#{current_user.access_token}"
    }
    response = https_get('graph.facebook.com', '/fql', params)
    response.body
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
      not_yet.each do |mov|
        json_data = get_movie_info(mov.video)
        info = JSON.parse(json_data)
        unless info["data"].blank?
          mov.meta = info["data"][0]["src"]
          mov.picture = info["data"][0]["thumbnail_link"]
          mov.source = info["data"][0]["src_hq"]
          mov.length = info["data"][0]["length"]
          mov.save
        end
      end
    end
  end

  def hq_src(video_id)
    json_data = get_movie_info(video_id)
    info = JSON.parse(json_data)
    unless info["data"].blank?
      return info["data"][0]["src_hq"]
    end
    return nil
  end

  def sec2strtime(msec)
    sec_work = msec.to_f.truncate.to_i
    min = sec_work / 60
    sec = sec_work % 60
    hour = sec_work / 3600
    strtime = "%02d:%02d"%([min,sec])
  end
end
