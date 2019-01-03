class CreateCollectionBins < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_bins do |t|
      t.string :option

      t.timestamps
    end
  end
end
