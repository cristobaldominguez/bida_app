class AddCountryToPlant < ActiveRecord::Migration[5.2]
  def change
    add_reference :plants, :country, foreign_key: true
  end
end
