class AddActiveToAlert < ActiveRecord::Migration[5.2]
  def change
    add_column :alerts, :active, :boolean, default: true
  end
end
