class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.references :group

      t.timestamps null: false
    end
  end
end
