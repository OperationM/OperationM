class AddConcertToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :concert_id, :integer
  end
end
