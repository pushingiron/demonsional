class ReferencesController < ApplicationController
  before_action :set_reference, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /references or /references.json
  def index
    @references = Reference.all
  end

  # GET /references/1 or /references/1.json
  def show; end

  # GET /references/new
  def new
    @reference = Reference.new
  end

  # GET /references/1/edit
  def edit; end

  # POST /references or /references.json
  def create
    @reference = Reference.new(reference_params)

    respond_to do |format|
      if @reference.save
        format.html { redirect_to @reference, notice: "Reference was successfully created." }
        format.json { render :show, status: :created, location: @reference }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /references/1 or /references/1.json
  def update
    respond_to do |format|
      if @reference.update(reference_params)
        format.html { redirect_to @reference, notice: "Reference was successfully updated." }
        format.json { render :show, status: :ok, location: @reference }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /references/1 or /references/1.json
  def destroy
    @reference.destroy
    respond_to do |format|
      format.html { redirect_to references_url, notice: "Reference was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_reference
    @reference = @shipping_order.references.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def reference_params
    params.require(:reference).permit(:shipping_order_id, :reference_type, :reference_value, :is_primary, :shipping_order_id)
  end
end
