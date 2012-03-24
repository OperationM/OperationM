class AddBandToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :band_id, :integer
  end
end
