class TagsController < ApplicationController
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

  # tags GET    /tags(.:format)
  # パラメーターで渡ってきた文字を含むタグを返す
  def index
    @tags = Tag.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json {render :json => @tags.map(&:attributes)}
    end
  end

  # POST   /movies/:movie_id/tags(.:format)
  # パラメーターで渡ってきたtagを作成して返す
  def create
    @tag = Tag.new(:name => params[:name])

    if @tag.save
      respond_to do |format|
        format.html
        format.json {render :json => @tag}
      end
    else
      render :json => {:error => @tag.errors, status: :unprocessable_entity}
    end
  end

  # PUT    /tags/:id(.:format)
  # 動画にタグを関連させる
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

  # tags GET    /tags(.:format)
  # movieからtagの関連を削除する
  def destroy
    movie = Movie.find(params[:movie])
    tag = Tag.find(params[:id])
    movie.tags.delete(tag)

    if movie.save
      respond_to do |format|
        format.html
        format.json {render :json => tag}
      end
    else
      render :json => {:error => movie.errors, status: :unprocessable_entity}
    end
  end

end
