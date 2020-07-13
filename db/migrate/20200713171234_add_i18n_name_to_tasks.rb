class AddI18nNameToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :i18n_name, :jsonb, default: {}
  end
end
