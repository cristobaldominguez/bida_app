class AddIndexToTodoDetail < ActiveRecord::Migration[5.2]
  def change
    add_index :todos, :detail, using: :gin
  end
end
