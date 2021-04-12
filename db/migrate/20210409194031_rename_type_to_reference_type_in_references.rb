class RenameTypeToReferenceTypeInReferences < ActiveRecord::Migration[6.1]
  def up
    rename_column :references, :type, :reference_type
    rename_column :references, :value, :reference_value
  end

  def down
    rename_column :references, :reference_type, :type
    rename_column :references, :reference_value, :value
  end
end
