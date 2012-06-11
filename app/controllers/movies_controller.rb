class MoviesController < ApplicationController
  before_filter :authenticate_member
  before_filter :authenticate_admin, :only => :new

  # 動画検索
  def search
    @keyword = params[:search_input]
    @movies = Movie.search(@keyword)

    respond_to do |format|
      format.html
      format.json { render json: @movies}
    end
  end

  # movies GET    /movies(.:format) 
  # 動画一覧表示
  def index
    fetch_movie_src
    @movies = Movie.scoped.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # movie GET    /movies/:id(.:format)
  # 一つの動画を表示
  def show
    @movie = Movie.find(params[:id])
    gon.token = current_user.access_token
    gon.movie_id = @movie.id

    # 新規コメント用
    @comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie}
    end
  end

  # new_movie GET    /movies/new(.:format)
  # 動画投稿のフォームに渡す
  def new
    @movie = Movie.new
    gon.token = current_user.access_token

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # edit_movie GET    /movies/:id/edit(.:format)
  # 編集対象のmovie
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST   /movies(.:format)
  # フォームから送られてきた内容を登録
  def create
    @movie = Movie.new(:video => params[:movie][:video])
    @movie.update_concert_and_band(params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to new_movie_path, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: new_movie_path }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT    /movies/:id(.:format) 
  # 動画の情報を更新
  def update
    @movie = Movie.find(params[:id])
    @movie.update_concert_and_band(params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/:id(.:format)
  # 動画を削除
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :ok }
    end
  end
end
