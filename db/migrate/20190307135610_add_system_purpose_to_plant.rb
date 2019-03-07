class AddSystemPurposeToPlant < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :system_purpose, :string
  end
end
