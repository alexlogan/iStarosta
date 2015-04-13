class AddIndexesToLogs < ActiveRecord::Migration
  def change
    add_index :logs, :lesson_id, name: 'logs_lesson_idx'
    add_index :logs, [:student_id, :flag, :block], name: 'logs_student_id_flag_block'
  end
end

