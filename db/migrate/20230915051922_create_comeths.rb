class CreateComeths < ActiveRecord::Migration[7.0]
  def change
    create_table :comeths do |t|

      t.timestamps
    end
  end
end
