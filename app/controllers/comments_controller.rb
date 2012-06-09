class CommentsController < ApplicationController
  before_filter :authenticate_member, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def create
    @movie = Movie.find(params[:comment][:movie_id])
    @comment = Comment.create(params[:comment])
    @comment.omniuser = current_user
    @comment.movie = @movie
    @comments = @movie.comments

    if @comment.save
      flash[:success] = "Comment created!"
    end

    respond_to do |format|
      format.html { redirect_to movie_path(@movie) }
      format.js
    end

  end

  def destroy
    @movie = @comment.movie
    @comment.destroy
    @comments = @movie.comments

    respond_to do |format|
      format.html { redirect_to movie_path(@movie.id) }
      format.js
    end
    
  end

  private

  def authorized_user
    @comment = Comment.find(params[:id])
  end
end
