class CreatePaths < ActiveRecord::Migration[6.1]
  def change
    create_table :paths do |t|
      t.text :description
      t.string :object
      t.string :action

      t.timestamps
    end
  end
end
