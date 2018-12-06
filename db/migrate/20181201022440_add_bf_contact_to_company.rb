class AddBfContactToCompany < ActiveRecord::Migration[5.2]
  def change
    add_reference :companies, :bf_contact
  end
end
