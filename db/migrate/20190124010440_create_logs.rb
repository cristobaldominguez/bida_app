class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.references :logbook, foreign_key: true
      t.references :log_standard, foreign_key: true
      t.boolean :active, default: true
      t.string :value

      t.timestamps
    end
  end
end
