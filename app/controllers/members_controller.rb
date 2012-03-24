class MembersController < ApplicationController
  before_filter :authenticate_member
  before_filter :check_ajax, :only => "create, destroy"

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
    @member = Member.find_by_name_or_create(params)
    @movie.members << @member
        
    respond_to do |format|
      if @movie.save
        format.json {render :json => @member}
      else
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/:id(.:format)
  # 動画の関連を削除する。メンバー自体は削除しない
  def destroy
    movie = Movie.find(params[:movie])
    member = Member.find(params[:id])
    movie.members.delete(member)

    respond_to do |format|
      if movie.save
        format.json {render :json => member}
      else
        format.json { render json: movie.errors, status: :unprocessable_entity }
      end
    end
  end

end

