class AddActiveToSamplingList < ActiveRecord::Migration[5.2]
  def change
    add_column :sampling_lists, :active, :boolean, default: true
  end
end
