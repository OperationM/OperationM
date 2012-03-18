class AddVideoToMovie < ActiveRecord::Migration
  def change
    add_column :movies, :video, :string
  end
end
