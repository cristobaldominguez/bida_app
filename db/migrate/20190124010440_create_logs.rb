class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.references :logbook, foreign_key: true
      t.boolean :active, default: true
      t.string :value
      t.date :date, default: -> { 'CURRENT_DATE' }

      t.timestamps
    end
  end
end
