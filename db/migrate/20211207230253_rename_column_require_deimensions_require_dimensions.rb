class RenameColumnRequireDeimensionsRequireDimensions < ActiveRecord::Migration[6.1]
  def change
    rename_column :contracts, :require_deimensions, :require_dimensions
  end
end
