class ShippingOrdersController < ApplicationController
  before_action :set_shipping_order, only: %i[ show edit update destroy ]

  # GET /shipping_orders or /shipping_orders.json
  def index
    @shipping_orders = ShippingOrder.all
  end

  # GET /shipping_orders/1 or /shipping_orders/1.json
  def show
  end

  # GET /shipping_orders/new
  def new
    @shipping_order = current_user.shipping_orders.new
  end

  # GET /shipping_orders/1/edit
  def edit
  end

  # POST /shipping_orders or /shipping_orders.json
  def create
    @shipping_order = current_user.shipping_orders.new(shipping_order_params)

    respond_to do |format|
      if @shipping_order.save
        format.html { redirect_to @shipping_order, notice: "Shipping order was successfully created." }
        format.json { render :show, status: :created, location: @shipping_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shipping_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shipping_orders/1 or /shipping_orders/1.json
  def update
    respond_to do |format|
      if @shipping_order.update(shipping_order_params)
        format.html { redirect_to @shipping_order, notice: "Shipping order was successfully updated." }
        format.json { render :show, status: :ok, location: @shipping_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shipping_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_orders/1 or /shipping_orders/1.json
  def destroy
    @shipping_order.destroy
    respond_to do |format|
      format.html { redirect_to shipping_orders_url, notice: "Shipping order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipping_order
      @shipping_order = current_user.shipping_orders.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shipping_order_params
      p 'shipping order params!!!'
      p params
      params.require(:shipping_order).permit(:payment_method, :cust_acct_num, :user_id,
                                             {locations_attributes: [ :id, :shipping_order_id, :loc_code, :name, :address1, :address2, :city, :state, :postal, :country, :geo, :residential, :comments, :earliest_appt, :latest_appt, :stop_type]})
    end
end
