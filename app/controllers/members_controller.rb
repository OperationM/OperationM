class MembersController < ApplicationController
  before_filter :authenticate_member
  before_filter :check_ajax, :only => "create, destroy"

  # 権限チェック
  def authenticate_member
    redirect_to root_url, :notice => "Required log in as Member." unless member?
  end

  # AJAXのみ対応
  def check_ajax
    return redirect_to '/404.html' unless request.xhr?
  end

  # member GET    /members/:id(.:format)
  # メンバーに関連する情報表示
  def show
    @member = Member.find(params[:id])
    @movies = @member.movies

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movies }
    end
  end

  # members POST   /members(.:format)
  # 既に登録されているかをチェックして動画に関連させる
  def create
    @movie = Movie.find(params[:movie])
    @member = Member.find_by_id(params[:id])
    if@member.blank?
      @member = Member.create_with_id(params[:id])
      @member.name = params[:name]
    end
    @movie.members << @member
    
    if @member.save && @movie.save
      respond_to do |format|
        format.html
        format.json {render :json => @member}
      end
    else
      render :json => {:error => @member.errors, status: :unprocessable_entity}
    end
  end

  # DELETE /members/:id(.:format)
  # 動画の関連を削除する。メンバー自体は削除しない
  def destroy
    movie = Movie.find(params[:movie])
    member = Member.find(params[:id])
    movie.members.delete(member)

    if movie.save
      respond_to do |format|
        format.html
        format.json {render :json => member}
      end
    else
      render :json => {:error => movie.errors, status: :unprocessable_entity}
    end
  end

end

