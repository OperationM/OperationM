class CreateTrackkings < ActiveRecord::Migration
  def change
    create_table :trackkings do |t|
      t.integer :movie_id
      t.integer :track_id

      t.timestamps
    end
  end
end
