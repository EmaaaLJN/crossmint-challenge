class CreateSoloons < ActiveRecord::Migration[7.0]
  def change
    create_table :soloons do |t|

      t.timestamps
    end
  end
end
