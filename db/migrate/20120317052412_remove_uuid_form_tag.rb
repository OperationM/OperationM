class RemoveUuidFormTag < ActiveRecord::Migration
  def change
    remove_column :tags, :uuid, :string
  end
end
