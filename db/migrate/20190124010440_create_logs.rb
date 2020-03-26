class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.references :task, foreign_key: true
      t.references :logbook, foreign_key: true
      t.date :date, default: -> { 'CURRENT_DATE' }
      t.boolean :active, default: true
      t.string :value

      t.timestamps
    end
  end
end
