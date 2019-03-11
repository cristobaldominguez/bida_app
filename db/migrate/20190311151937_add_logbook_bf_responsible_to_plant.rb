class AddLogbookBfResponsibleToPlant < ActiveRecord::Migration[5.2]
  def change
    add_reference :plants, :logbook_bf_responsible
  end
end
