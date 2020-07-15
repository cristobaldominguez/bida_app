class AddIndexToTaskCommentAndName < ActiveRecord::Migration[5.2]
  def change
    add_index  :tasks, :i18n_name, using: :gin
    add_index  :tasks, :i18n_comment, using: :gin
  end
end
