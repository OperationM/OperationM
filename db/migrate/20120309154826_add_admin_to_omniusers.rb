class AddAdminToOmniusers < ActiveRecord::Migration
  def change
    add_column :omniusers, :admin, :boolean, :null => false, :default => false
  end
end
