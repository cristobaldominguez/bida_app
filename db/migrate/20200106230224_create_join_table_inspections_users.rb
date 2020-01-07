class CreateJoinTableInspectionsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :inspections, :users do |t|
      # t.index [:inspection_id, :user_id]
      # t.index [:user_id, :inspection_id]
    end
  end
end
