class CommentsController < ApplicationController
  before_filter :authenticate_member, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def create
    @movie = Movie.find(params[:comment][:movie_id])
    @comment = Comment.create(params[:comment])
    @comment.omniuser = current_user
    @comment.movie = @movie

    if @comment.save
      flash[:success] = "Comment created!"
    end
    redirect_to movie_path(@movie)

  end

  def destroy
    @comment.destroy
    
  end

  private

  def authorized_user
    raise params.inspect
    @comment = Comment.find(params[:id])
  end
end
