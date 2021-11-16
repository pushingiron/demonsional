class CreateTransports < ActiveRecord::Migration[6.1]
  def change
    create_table :transports do |t|

      t.timestamps
    end
  end
end
