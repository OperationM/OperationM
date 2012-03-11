class TagsController < ApplicationController
  before_filter :authenticate_member

  # 権限チェック
  def authenticate_member
    redirect_to root_url, :notice => "Required log in as Member." unless member?
  end

  # POST   /movies/:movie_id/tags(.:format)
  # tagを作成してmovieに関連付ける
  def create
    return redirect_to '/404.html' unless request.xhr?
    @movie = Movie.find(params[:movie_id])
    @tag = Tag.new(params[:tag])
    @movie.tags << @tag

    if @tag.save && @movie.save
      html = render_to_string :partial => "tag", :collection => [@tag]
      render :json => {:status => :success, :html => html}
      logger.debug html
    else
      render :json => {:error => @tag.errors, status: :unprocessable_entity}
      logger.debug "#{@tag.errors}"
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

end
