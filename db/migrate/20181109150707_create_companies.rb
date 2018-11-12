class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.boolean :active, :default => true
      t.string :name
      t.string :taxid

      t.timestamps
    end
  end
end
