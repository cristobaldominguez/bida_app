class AddCurrentLogStandardIdToLog < ActiveRecord::Migration[5.2]
  def change
    add_reference :logs, :current_log_standard, foreign_key: true
  end
end
