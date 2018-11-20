class AddAddress01ToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :address01, :string
  end
end
