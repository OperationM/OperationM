class AddMemberToOmniusers < ActiveRecord::Migration
  def change
    add_column :omniusers, :member, :boolean, :null => false, :default => false
  end
end
