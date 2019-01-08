class CreateSupports < ActiveRecord::Migration[5.2]
  def change
    create_table :supports do |t|
      t.boolean :active, null: false, default: true
      t.date :start_date
      t.date :end_date
      t.boolean :client_onsite
      t.references :client
      t.references :bf_technician

      t.timestamps
    end
  end
end
