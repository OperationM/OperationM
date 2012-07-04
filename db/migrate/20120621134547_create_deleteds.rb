class CreateDeleteds < ActiveRecord::Migration
  def change
    create_table :deleteds do |t|
      t.string :video
      t.string :band
      t.string :concert
      t.string :user

      t.timestamps
    end
  end
end
