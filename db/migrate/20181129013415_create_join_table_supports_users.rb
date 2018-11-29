class CreateJoinTableSupportsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :supports, :users do |t|
      # t.index [:support_id, :user_id]
      # t.index [:user_id, :support_id]
    end
  end
end
