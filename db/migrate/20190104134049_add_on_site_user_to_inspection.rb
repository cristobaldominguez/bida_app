class AddOnSiteUserToInspection < ActiveRecord::Migration[5.2]
  def change
    add_reference :inspections, :on_site_user
  end
end
