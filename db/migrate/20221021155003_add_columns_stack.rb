class AddColumnsStack < ActiveRecord::Migration[7.0]
  def change
    add_reference :stacks, :game
    add_reference :stacks, :player
    add_column :stacks, :cards, :array
    add_reference :stacks, :game
  end
end
