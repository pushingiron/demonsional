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
=begin
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
=end

  def update
    @shipping_order = current_user.shipping_orders.find(params[:id])
    #    @pickup_locations = @shipping_order.locations.find_by(stop_type: :Pickup)
    #@drop_locations = @shipping_order.locations.find_by(stop_type: :Drop)
    # Reference Handling
    if params[:add_reference]
      # rebuild the ingredient attributes that doesn't have an id
      unless params[:shipping_order][:references_attributes].blank?
        params[:shipping_order][:references_attributes].each do |attribute|
          params.require(:shipping_order).permit!
          @shipping_order.references.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      # add one more empty ingredient attribute
      @shipping_order.references.build
    elsif params[:remove_reference]
      # collect all marked for delete ingredient ids
      removed_references = params[:shipping_order][:references_attributes].to_unsafe_h.map { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Reference.delete(removed_references)
      flash[:notice] = "References removed."
      params[:shipping_order][:references_attributes].each do |attribute|
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @shipping_order.references.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    elsif params[:add_pickup_location]
      # rebuild the location attributes that doesn't have an id
      unless params[:shipping_order][:pickup_location_attributes].blank?
        params[:shipping_order][:pickup_location_attributes].each do |attribute|
          params.require(:shipping_order).permit!
          @shipping_order.pickup_locations.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      # add one more empty loction attribute
      @shipping_order.pickup_locations.build
    elsif params[:remove_pickup_location]
      # collect all marked for delete location ids
      removed_pickup_locations = params[:shipping_order][:pickup_location_attributes].to_unsafe_h.map { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Reference.delete(removed_pickup_locations)
      flash[:notice] = "Pickup location removed."
      params[:shipping_order][:pickup_location_attributes].each do |attribute|
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @shipping_order.pickup_locations.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    elsif params[:add_drop_location]
      # rebuild the locations attributes that doesn't have an id
      unless params[:shipping_order][:drop_location_attributes].blank?
        params[:shipping_order][:drop_location_attributes].each do |attribute|
          params.require(:shipping_order).permit!
          @shipping_order.drop_locations.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      # add one more empty location attribute
      @shipping_order.drop_locations.build
    elsif params[:remove_drop_location]
      # collect all marked for delete location ids
      removed_drop_locations = params[:shipping_order][:drop_location_attributes].to_unsafe_h.map { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Reference.delete(removed_drop_locations)
      flash[:notice] = "Drop location removed."
      params[:shipping_order][:locations_attributes].each do |attribute|
          # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
          @shipping_order.drop_locations.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
        end
      elsif params[:add_item]
      # rebuild the locations attributes that doesn't have an id
      unless params[:shipping_order][:items_attributes].blank?
        params[:shipping_order][:items_attributes].each do |attribute|
          params.require(:shipping_order).permit!
          @shipping_order.items.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      # add one more empty location attribute
      @shipping_order.items.build
    elsif params[:remover_item]
      # collect all marked for delete location ids
      removed_items = params[:shipping_order][:items_attributes].to_unsafe_h.map { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Reference.delete(removed_items)
      flash[:notice] = "Item removed."
      params[:shipping_order][:items_attributes].each do |attribute|
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @shipping_order.items.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
      else
        # save goes like usual
        if @shipping_order.update(shipping_order_params)
          flash[:notice] = "Successfully updated ShippingOrder"
          redirect_to @shipping_order and return
        end
    end
    render :action => 'edit'
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
    params.require(:shipping_order).permit(:payment_method, :cust_acct_num, :user_id, :update_attributes,
                                           { pickup_locations_attributes: %i[id shipping_order_id loc_code name address1 address2 city state postal country geo residential comments earliest_appt latest_appt stop_type loc_type] },
                                           { drop_locations_attributes: %i[id shipping_order_id loc_code name address1 address2 city state postal country geo residential comments earliest_appt latest_appt stop_type loc_type] },
                                           { references_attributes: %i[id reference_type reference_value is_primary shipping_order_id _destroy] },
                                           { items_attributes: %i[id type sequence line_number description freight_class weight weight_uom quantity quantity_uom cube cube_uom shipping_orders]})
  end
end
