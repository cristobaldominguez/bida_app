class AddUserIdToSupports < ActiveRecord::Migration[5.2]
  def change
    add_reference :supports, :user, foreign_key: true
  end
end
