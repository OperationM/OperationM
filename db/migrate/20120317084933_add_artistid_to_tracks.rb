class AddArtistidToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :artist_id, :integer
  end
end
