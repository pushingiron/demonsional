class ShippingOrderDatesController < ApplicationController
  before_action :set_shipping_order_date, only: %i[ show edit update destroy ]

  # GET /shipping_order_dates or /shipping_order_dates.json
  def index
    @shipping_order_dates = ShippingOrderDate.all
  end

  # GET /shipping_order_dates/1 or /shipping_order_dates/1.json
  def show
  end

  # GET /shipping_order_dates/new
  def new
    @shipping_order_date = ShippingOrderDate.new
  end

  # GET /shipping_order_dates/1/edit
  def edit
  end

  # POST /shipping_order_dates or /shipping_order_dates.json
  def create
    @shipping_order_date = ShippingOrderDate.new(shipping_order_date_params)

    respond_to do |format|
      if @shipping_order_date.save
        format.html { redirect_to @shipping_order_date, notice: "Shipping order date was successfully created." }
        format.json { render :show, status: :created, location: @shipping_order_date }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shipping_order_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shipping_order_dates/1 or /shipping_order_dates/1.json
  def update
    respond_to do |format|
      if @shipping_order_date.update(shipping_order_date_params)
        format.html { redirect_to @shipping_order_date, notice: "Shipping order date was successfully updated." }
        format.json { render :show, status: :ok, location: @shipping_order_date }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shipping_order_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_order_dates/1 or /shipping_order_dates/1.json
  def destroy
    @shipping_order_date.destroy
    respond_to do |format|
      format.html { redirect_to shipping_order_dates_url, notice: "Shipping order date was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipping_order_date
      @shipping_order_date = ShippingOrderDate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shipping_order_date_params
      params.require(:shipping_order_date).permit(:date_type, :date_value, :shipping_orders)
    end
end
