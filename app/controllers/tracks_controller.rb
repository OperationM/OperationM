class TracksController < ApplicationController
  before_filter :authenticate_member
  before_filter :check_ajax, :only => "create, destroy, update"

  # 権限チェック
  def authenticate_member
    redirect_to root_url, :notice => "Required log in as Member." unless member?
  end

  # AJAXのみ対応
  def check_ajax
    return redirect_to '/404.html' unless request.xhr?
  end

  # tracks POST   /tracks(.:format) 
  # パラメーターからtrackとartistを検索または作成して返す
  def create
    if params.has_key?("movie")
      logger.debug "update relation"
      @artist = Artist.find_by_id(params[:artist_id])
      if @artist.blank?
        @artist = Artist.create_with_id(params[:artist_id])
        @artist.name = params[:artist]
      end
      @track = @artist.tracks.find_by_id(params[:track_id])
      if @track.blank?
        @track = Track.create_with_id(params[:track_id])
        @track.name = params[:track]
        @track.art_work_url_30 = params[:art_work_url_30]
        @artist.tracks << @track
      end
      @movie = Movie.find(params[:movie])
      @movie.tracks << @track
      @movie.save
    else
      logger.debug "new track"
      @artist = Artist.find_by_name(params[:artist]) || Artist.new(:name => params[:artist])
      @track = @artist.tracks.find_by_name(params[:track])
      if @track.blank?
        @track = Track.new
        @track.name = params[:track]
        @track.art_work_url_30 = params[:art_work_url_30]
        @artist.tracks << @track
      end
    end

    if @track.save && @artist.save
      respond_to do |format|
        format.html
        format.json {render :json => @track.to_json(:include => [:artist])}
      end
    else
      render :json => {:error => @track.errors, status: :unprocessable_entity}
    end
  end

  # PUT    /tracks/:id(.:format)
  # 動画に曲を関連させる
  def update
    @movie = Movie.find(params[:movie])
    @tag = Tag.find(params[:id])
    @movie.tags << @tag
    if @tag.save && @movie.save
      respond_to do |format|
        format.html
        format.json {render :json => @tag}
      end
    else
      render :json => {:error => @tag.errors, status: :unprocessable_entity}
    end
  end

  # track GET    /tracks/:id(.:format) 
  # 曲に関連づいている動画を返す
  def show
    @track = Track.find(params[:id])
    @movies = @track.movies

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movies }
    end
  end

  # DELETE /tracks/:id(.:format)
  # 動画から曲の関連を削除する
  def destroy
    movie = Movie.find(params[:movie])
    track = Track.find(params[:id])
    movie.tracks.delete(track)

    if movie.save
      respond_to do |format|
        format.html
        format.json {render :json => track}
      end
    else
      render :json => {:error => movie.errors, status: :unprocessable_entity}
    end
  end
end
