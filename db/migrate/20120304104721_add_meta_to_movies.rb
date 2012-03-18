class AddMetaToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :meta, :string
  end
end
