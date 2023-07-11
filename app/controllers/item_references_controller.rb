class ItemReferencesController < ApplicationController
  before_action :set_item_reference, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def destroy
    @item_reference.destroy
    respond_to do |format|
      format.html { redirect_to references_url, notice: "Reference was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item_reference
    @reference = @shipping_order.references.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reference_params
    params.require(:reference).permit(:item_id, :reference_type, :reference_value, :is_primary)
  end
end
