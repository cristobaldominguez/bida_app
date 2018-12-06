class AddContactToCompany < ActiveRecord::Migration[5.2]
  def change
    add_reference :companies, :contact
  end
end
