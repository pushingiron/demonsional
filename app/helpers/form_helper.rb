module FormHelper
  def setup_pickup_location(shipping_order)
    shipping_order.pickup_locations ||= Location.new
    shipping_order
  end

  def setup_drop_location(shipping_order)
    shipping_order.drop_locations ||= Location.new
    shipping_order
  end

end