class AddColorToSoloons < ActiveRecord::Migration[7.0]
  def change
    add_column :soloons, :color, :integer, default: 0
  end
end
