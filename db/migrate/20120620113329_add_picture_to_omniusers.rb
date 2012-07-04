class AddPictureToOmniusers < ActiveRecord::Migration
  def change
    add_column :omniusers, :picture, :string
  end
end
