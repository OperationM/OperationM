class BandsController < ApplicationController
  def show
    @band = Band.find(params[:id])
    @movies = @band.movies.page(params[:page])

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
