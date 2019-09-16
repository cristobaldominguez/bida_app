class AddEmployeeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :employee, :integer, default: 0
  end
end
