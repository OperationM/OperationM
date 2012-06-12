class CommentsController < ApplicationController

  def create
    @movie = Movie.find(params[:comment][:movie_id])
    @comment = Comment.create(params[:comment])
    @comment.omniuser = current_user
    @comment.movie = @movie
    @comment.save

    respond_to do |format|
      format.html { redirect_to movie_path(@movie) }
      format.js
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @movie = @comment.movie
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to movie_path(@movie.id) }
      format.js
    end
    
  end

  def show_all_comments
    @movie = Movie.find(params[:movie_id])
  end

end
