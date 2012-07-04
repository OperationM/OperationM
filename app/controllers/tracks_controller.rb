class TracksController < ApplicationController
  before_filter :authenticate_member
  before_filter :check_ajax, :only => "create, destroy"

  # track GET    /tracks/:id(.:format) 
  # 曲に関連づいている動画を返す
  def show
    @track = Track.find(params[:id])
    @movies = @track.movies.page(params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movies }
    end
  end

  # tracks POST   /tracks(.:format) 
  # パラメーターからtrackとartistを検索または作成して返す
  def create
    @movie = Movie.find(params[:movie])
    @track = Track.find_by_name_or_create(params)
    @movie.tracks << @track
    
    respond_to do |format|
      if @movie.save
        format.json { render :json => @track.to_json(:include => [:artist]) }
      else
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/:id(.:format)
  # 動画から曲の関連を削除する
  def destroy
    movie = Movie.find(params[:movie])
    track = Track.find(params[:id])
    movie.tracks.delete(track)
    
    respond_to do |format|
      if movie.save
        format.json { render :json => track }
      else
        format.json { render json: movie.errors, status: :unprocessable_entity }
      end
    end
  end
end
