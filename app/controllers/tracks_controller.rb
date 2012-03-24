class TracksController < ApplicationController
  before_filter :authenticate_member
  before_filter :check_ajax, :only => "create, destroy"

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

  # tracks POST   /tracks(.:format) 
  # パラメーターからtrackとartistを検索または作成して返す
  def create
    @artist = Artist.find_by_name(params[:artist])
    if @artist.blank?
      @artist = Artist.create
      @artist.name = params[:artist]
    end
    @track = @artist.tracks.find_by_name(params[:track])
    if @track.blank?
      @track = Track.create
      @track.name = params[:track]
      @track.art_work_url_30 = params[:artwork]
      @artist.tracks << @track
    end
    @movie = Movie.find(params[:movie])
    @movie.tracks << @track

    if @track.save && @artist.save && @movie.save
      respond_to do |format|
        format.html
        format.json {render :json => @track.to_json(:include => [:artist])}
      end
    else
      render :json => {:error => @track.errors, status: :unprocessable_entity}
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
