class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :current_semester, null: false, default: 1
      t.integer :current_block, null: false, default: 1
      t.date :threshold_date
      t.references :group, null: false
      t.timestamps null: false
    end
  end
end
