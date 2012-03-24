class AddLiveToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :live_id, :integer
  end
end
