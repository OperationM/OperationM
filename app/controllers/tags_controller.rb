class TagsController < ApplicationController
  before_filter :authenticate_member
  before_filter :check_ajax, :only => "create, destroy"

  # tags GET    /tags(.:format)
  # パラメーターで渡ってきた文字を含むタグを返す
  def index
    @tags = Tag.where("name like ?", "%#{params[:q]}%")

    respond_to do |format|
      format.json {render :json => @tags.map(&:attributes)}
    end
  end
  
  # tag GET    /tags/:id(.:format)
  # tagに関連付いている動画を返す
  def show
    @tag = Tag.find(params[:id])
    @movies = @tag.movies

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movies }
    end
  end

  # POST   /movies/:movie_id/tags(.:format)
  # パラメーターで渡ってきたtagを作成して返す
  def create
    @movie = Movie.find(params[:movie])
    @tag = Tag.find_by_name_or_create(params)
    @movie.tags << @tag

    respond_to do |format|
      if @movie.save
        format.json { render :json => @tag }
      else
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # tags GET    /tags(.:format)
  # movieからtagの関連を削除する
  def destroy
    movie = Movie.find(params[:movie])
    tag = Tag.find(params[:id])
    movie.tags.delete(tag)

    respond_to do |format|
      if movie.save
        format.json {render :json => tag}
      else
        format.json { render json: movie.errors, status: :unprocessable_entity }
      end
    end
  end

end
