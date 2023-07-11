class CreateItemReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :item_references do |t|
      t.string :type
      t.string :value
      t.boolean :is_primary
      t.references :items, null: false, foreign_key: true
      t.timestamps
    end
  end
end
