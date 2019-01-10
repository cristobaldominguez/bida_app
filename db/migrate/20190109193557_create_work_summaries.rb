class CreateWorkSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :work_summaries do |t|
      t.references :support, foreign_key: true
      t.boolean :active, default: true
      t.string :description
      t.integer :hours
      t.text :materials

      t.timestamps
    end
  end
end
