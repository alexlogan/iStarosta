class AddTransactionIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :transaction_id, :integer, null: false, default: 0
  end
end
