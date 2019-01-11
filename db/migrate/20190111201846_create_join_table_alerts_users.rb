class CreateJoinTableAlertsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :alerts, :users do |t|
      # t.index [:alert_id, :user_id]
      # t.index [:user_id, :alert_id]
    end
  end
end
