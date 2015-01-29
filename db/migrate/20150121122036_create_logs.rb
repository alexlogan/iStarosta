class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :student, null: false
      t.references :lesson, null: false
      t.boolean :flag, null: false, default: false
      t.date :date, null: false

      t.timestamps null: false
    end
  end
end
