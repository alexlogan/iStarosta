class CreateMedicalCertificates < ActiveRecord::Migration
  def change
    create_table :medical_certificates do |t|
      t.references :student, null: false
      t.integer :semester, null: false
      t.date :from, null: false
      t.date :till, null: false
      t.timestamps null: false
    end
  end
end
