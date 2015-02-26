class DropAbsences < ActiveRecord::Migration
  def change
    drop_table :absences
  end
end
