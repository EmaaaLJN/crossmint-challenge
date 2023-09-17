class CreateCoordenates < ActiveRecord::Migration[7.0]
  def change
    create_table :coordenates do |t|
      t.references :target, polymorphic: true, null: false
      t.integer :x
      t.integer :y
      t.timestamps
    end
  end
end
