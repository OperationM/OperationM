class AddOmniuseridToComments < ActiveRecord::Migration
  def change
    add_column :comments, :omniuser_id, :integer
  end
end
