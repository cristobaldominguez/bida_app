class AddSystemSizeToPlant < ActiveRecord::Migration[5.2]
  def change
    add_column :plants, :system_size, :string
  end
end
