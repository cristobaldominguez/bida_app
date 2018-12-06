class AddBfContactToPlant < ActiveRecord::Migration[5.2]
  def change
    add_reference :plants, :bf_contact
  end
end
