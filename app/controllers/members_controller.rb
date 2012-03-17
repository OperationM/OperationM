class MembersController < ApplicationController
  before_filter :authenticate_member
  # before_filter :check_ajax, :only => "create, destroy"

  # 権限チェック
  def authenticate_member
    redirect_to root_url, :notice => "Required log in as Member." unless member?
  end

  # AJAXのみ対応
  def check_ajax
    return redirect_to '/404.html' unless request.xhr?
  end

  def show
  end

  def create
    @movie = Movie.find(params[:movie])
    @member = Member.find_by_id(params[:id]) || Member.create_with_id_and_name(params[:id], params[:name])
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

