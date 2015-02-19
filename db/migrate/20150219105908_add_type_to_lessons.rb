class AddTypeToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :kind, :integer
  end
end
