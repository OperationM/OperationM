class TagsController < ApplicationController
  before_filter :authenticate_member

  # 権限チェック
  def authenticate_member
    redirect_to root_url, :notice => "Required log in as Member." unless member?
  end

  # GET    /movies/:movie_id/tags(.:format)
  # movie_tags
  # movieに関連付けされているtagsを返す
  def index
    movie = Movie.find(params[:movie_id])
    @tags = @movie.tags

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET    /movies/:movie_id/tags/new(.:format) 
  # new_movie_tag
  # 新規tagを返す
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # POST   /movies/:movie_id/tags(.:format)
  # tagを作成してmovieに関連付ける
  def create
    movie = Movie.find(params[:movie_id])
    @tag = Tag.new(params[:tag])
    movie.tags << @tag

    respond_to do |format|
      if @tag.save && movie.save
        format.html { redirect_to @tag, notice: 'Movie was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /movies/:movie_id/tags/:id(.:format)
  # movie_tag
  # tagに関連付いているmoviesを返す
  def show
    @tag = Tag.find(params[:id])
    @movies = @tag.movies

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movies }
    end
  end

  # DELETE /movies/:movie_id/tags/:id(.:format)
  # movieからtagの関連を削除する
  def destroy
    movie = Movie.find(params[:movie_id])
    tag = Tag.find(params[:id])
    movie.tags.delete(tag)

    respond_to do |format|
      if movie.save
        format.html { redirect_to movie }
        format.json { head :ok }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
    end
  end

end
