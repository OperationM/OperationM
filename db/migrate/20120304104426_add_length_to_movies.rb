class AddLengthToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :length, :string
  end
end
