class AddSourceToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :source, :string
  end
end
