class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :type
      t.integer :sequence
      t.integer :line_number
      t.string :description
      t.string :freight_class
      t.float :weight
      t.string :weight_uom
      t.float :quantity
      t.string :quantity_uom
      t.float :cube
      t.string :cube_uom
      t.references :shipping_order

      t.timestamps
    end
  end
end
