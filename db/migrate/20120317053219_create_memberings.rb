class CreateMemberings < ActiveRecord::Migration
  def change
    create_table :memberings do |t|
      t.integer :movie_id
      t.integer :member_id

      t.timestamps
    end
  end
end
