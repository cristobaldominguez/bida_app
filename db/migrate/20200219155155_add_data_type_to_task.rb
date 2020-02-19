class AddDataTypeToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :data_type, :integer, default: 0
  end
end
