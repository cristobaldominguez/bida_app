class AddSortToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :sort, :integer, default: 1
  end
end
