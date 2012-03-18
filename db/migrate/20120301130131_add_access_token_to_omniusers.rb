class AddAccessTokenToOmniusers < ActiveRecord::Migration
  def change
    add_column :omniusers, :access_token, :string
  end
end
