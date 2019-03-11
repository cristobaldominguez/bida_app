class AddLogbookCompanyResponsibleToPlant < ActiveRecord::Migration[5.2]
  def change
    add_reference :plants, :logbook_company_responsible
  end
end
