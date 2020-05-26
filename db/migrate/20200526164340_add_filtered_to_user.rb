class AddFilteredToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :filtered, :boolean, default: false
  end
end
