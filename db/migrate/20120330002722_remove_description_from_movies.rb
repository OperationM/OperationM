class RemoveDescriptionFromMovies < ActiveRecord::Migration
  def up
    remove_column :movies, :description
  end

  def down
    add_column :movies, :description, :string
  end
end
