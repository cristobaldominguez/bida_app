class AddI18nCommentToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :i18n_comment, :jsonb, default: {}
  end
end
