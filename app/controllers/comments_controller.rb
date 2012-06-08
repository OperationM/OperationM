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
    movie_id = @comment.movie.id
    @comment.destroy
    redirect_to movie_path(movie_id)
    
  end

  private

  def authorized_user
    @comment = Comment.find(params[:id])
  end
end
