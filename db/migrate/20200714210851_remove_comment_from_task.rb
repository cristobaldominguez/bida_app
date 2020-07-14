class RemoveCommentFromTask < ActiveRecord::Migration[5.2]
  def change
    remove_column :tasks, :comment, :string
  end
end
