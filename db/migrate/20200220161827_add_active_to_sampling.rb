class AddActiveToSampling < ActiveRecord::Migration[5.2]
  def change
    add_column :samplings, :active, :boolean, default: true
  end
end
