class ShippingOrdersController < ApplicationController

  include MercuryGateService

  before_action :set_shipping_order, except: %i[index post_xml new create import_page csv_example import destroy_all]
  before_action :authenticate_user!


  # GET /shipping_orders or /shipping_orders.json
  def index
    # @so_match = Profile.so_match_reference(current_user)
      @shipping_orders = current_user.shipping_orders.all

  end

  # GET /shipping_orders/1 or /shipping_orders/1.json
  def show; end

  # GET /shipping_orders/new
  def new
    @shipping_order = current_user.shipping_orders.new
  end

  # GET /shipping_orders/1/edit
  def edit; end

  # POST /shipping_orders or /shipping_orders.json
  def create
    @shipping_order = current_user.shipping_orders.new(shipping_order_params)

    respond_to do |format|
      if @shipping_order.save
        format.html { redirect_to @shipping_order, notice: 'Shipping order was successfully created.' }
        format.json { render :show, status: :created, location: @shipping_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shipping_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_page;
  end

  def csv_example
    send_file 'app/assets/examples/so.csv'
  end

  def post_xml
    @shipping_orders = current_user.shipping_orders.all
    @response = mg_post_xml(current_user, shipping_order_xml(current_user, @shipping_orders))
    render inline: "<%= @response %><br><%= link_to 'back', shipping_orders_path %>"
    # redirect_to static_page_xml_response_path
    # redirect_to static_page_xml_response_path
  end

  def destroy_all
    if current_user.shipping_orders.first.present?
      current_user.items.each do |item|
        ItemReference.where(item_id: item.id).destroy_all
      end
      current_user.shipping_orders.destroy_all
      redirect_to shipping_orders_path, notice: 'All enterprises deleted'
    else
      redirect_to shipping_orders_path, notice: 'Nothing to deleted'
    end
  end

  def update
    @shipping_order = current_user.shipping_orders.find(params[:id])
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
      flash[:notice] = 'References removed.'
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
      removed_pickup_locations = params[:shipping_order][:pickup_locations_attributes].to_unsafe_h.map { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Location.delete(removed_pickup_locations)
      flash[:notice] = 'Pickup location removed.'
      params[:shipping_order][:pickup_locations_attributes].each do |attribute|
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @shipping_order.pickup_locations.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    elsif params[:add_delivery_location]
      # rebuild the locations attributes that doesn't have an id
      unless params[:shipping_order][:delivery_locations_attributes].blank?
        params[:shipping_order][:delivery_locations_attributes].each do |attribute|
          params.require(:shipping_order).permit!
          @shipping_order.delivery_locations.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      # add one more empty location attribute
      @shipping_order.delivery_locations.build
    elsif params[:remove_delivery_location]
      # collect all marked for delete location ids
      removed_delivery_locations = params[:shipping_order][:delivery_locations_attributes].to_unsafe_h.map { |i, att| att[:id] if (att[:id] && att[:_destroy].to_i == 1) }
      # physically delete the ingredients from database
      Location.delete(removed_delivery_locations)
      flash[:notice] = 'Delivery location removed.'
      params[:shipping_order][:delivery_locations_attributes].each do |attribute|
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @shipping_order.delivery_locations.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
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
      flash[:notice] = 'Item removed.'
      params[:shipping_order][:items_attributes].each do |attribute|
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @shipping_order.items.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    else
      # save goes like usual
      if @shipping_order.update(shipping_order_params)
        flash[:notice] = 'Successfully updated ShippingOrder'
        redirect_to @shipping_order and return
      end
    end
    render action: 'edit'
  end

  # DELETE /shipping_orders/1 or /shipping_orders/1.json
  def destroy
    @shipping_order.destroy
    respond_to do |format|
      format.html { redirect_to shipping_orders_url, notice: 'Shipping order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    current_user.shipping_orders.import(params[:file])
    redirect_to shipping_orders_path, notice: 'Shipping Orders Imported.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_shipping_order
    @shipping_order = current_user.shipping_orders.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def shipping_order_params
    params.require(:shipping_order).permit(:payment_method, :cust_acct_num, :user_id, :so_match_ref,
                                           :shipment_match_ref, :update_attributes, :early_pickup_date,
                                           :late_pickup_date, :early_delivery_date, :late_delivery_date, :demo_type,
                                           :equipment_code, :shipment_type,
                                           { pickup_locations_attributes: %i[id shipping_order_id loc_code name address1
                                                                             address2 city state postal country geo
                                                                             residential comments earliest_appt
                                                                             latest_appt stop_type loc_type contact_name
                                                                             contact_phone contact_email _destroy] },
                                           { delivery_locations_attributes: %i[id shipping_order_id loc_code name address1
                                                                               address2 city state postal country geo
                                                                               residential comments earliest_appt
                                                                               latest_appt stop_type loc_type contact_name
                                                                             contact_phone contact_email _destroy] },
                                           { references_attributes: %i[id reference_type reference_value is_primary
                                                                       shipping_order_id _destroy] },
                                           { items_attributes: %i[id type sequence line_number description freight_class
                                                                  weight_actual weight_uom quantity quantity_uom cube
                                                                  cube_uom shipping_orders_id _destroy weight_delivered
                                                                  country_of_origin country_of_manufacture customs_value
                                                                  customs_value_currency origination_country weight_plan
                                                                  manufacturing_country item_id _destroy] },
                                           { items_references_attributes: %i[id reference_type reference_value is_primary
                                                                       shipping_order_id _destroy] },
    )
  end
end
