class MoviesController < ApplicationController
  before_filter :authenticate_member
  before_filter :authenticate_admin, :only => :new

  # 権限チェック
  def authenticate_member
    redirect_to root_url, :notice => "Required log in as Member." unless member?
  end

  def authenticate_admin
    redirect_to root_url, :notice => "Required log in as Admin." unless admin?
  end

  # GET /movies
  # GET /movies.json
  def index
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
    ##### 以上が暫定対処

    @movies = Movie.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    gon.token = current_user.access_token
    gon.movie_id = @movie.id

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new
    # fbにajaxでpostするのでaccess_tokenを渡してやる必要がある
    # gonはjsに変数を渡せる便利gem。下記の場合js側で使う時もgon.tokenでOK
    gon.token = current_user.access_token

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :ok }
    end
  end
end
