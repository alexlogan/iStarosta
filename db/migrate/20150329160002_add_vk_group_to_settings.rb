class AddVkGroupToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :vk_group, :string
  end
end
