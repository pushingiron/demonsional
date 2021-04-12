class CreateReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :references do |t|
      t.string :type
      t.string :value
      t.boolean :is_primary
      t.references :shipping_orders, null: false, foreign_key: true

      t.timestamps
    end
  end
end
