class CreateAbsences < ActiveRecord::Migration
  def change
    create_table :absences do |t|
      t.references :student, null: false
      t.references :lesson, null: false
      t.integer :amount, null: false, default: 0
      t.timestamps null: false
    end
  end
end
