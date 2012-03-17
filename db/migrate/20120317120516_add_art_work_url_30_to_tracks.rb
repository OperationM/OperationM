class AddArtWorkUrl30ToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :art_work_url_30, :string
  end
end
