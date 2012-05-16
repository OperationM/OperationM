class StaticPagesController < ApplicationController
  def home
    if current_user
      redirect_to movies_path
    end
  end

  def help
  end

  def about
  end

end
