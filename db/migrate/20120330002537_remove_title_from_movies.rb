class RemoveTitleFromMovies < ActiveRecord::Migration
  def up
    remove_column :movies, :title
  end

  def down
    add_column :movies, :title, :string
  end
end
