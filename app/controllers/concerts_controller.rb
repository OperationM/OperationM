class ConcertsController < ApplicationController
  def show
    @concert = Concert.find(params[:id])
    @movies = @concert.movies

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movies }
    end
  end

  def create
  end

  def destroy
  end

end
