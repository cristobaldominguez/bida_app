class CreateJoinTableAlertsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :alerts, :users do |t|
      t.references :alerts, foreign_key: true
      t.references :users, foreign_key: true
    end
  end
end
