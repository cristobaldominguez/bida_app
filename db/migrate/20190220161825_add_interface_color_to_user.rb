class AddInterfaceColorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :interface_color, :integer, default: 0
  end
end
