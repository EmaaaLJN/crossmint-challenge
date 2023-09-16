class AddDirectionToComeths < ActiveRecord::Migration[7.0]
  def change
    add_column :comeths, :direction, :integer, default: 0
  end
end
