class AddAddress02ToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :address02, :string
  end
end
