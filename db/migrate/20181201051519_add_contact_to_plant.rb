class AddContactToPlant < ActiveRecord::Migration[5.2]
  def change
    add_reference :plants, :contact
  end
end
