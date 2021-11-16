class AddPrimaryReferenceToTransports < ActiveRecord::Migration[6.1]
  def change
    add_column :transports, :oid, :string
    add_column :transports, :primary_reference, :string
  end
end
