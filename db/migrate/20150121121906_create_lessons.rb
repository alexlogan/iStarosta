class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.integer :kind
      t.integer :semester, null: false, default: 1
      t.references :group

      t.timestamps null: false
    end
  end
end
