require "test_helper"

class ShippingOrderDatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipping_order_date = shipping_order_dates(:one)
  end

  test "should get index" do
    get shipping_order_dates_url
    assert_response :success
  end

  test "should get new" do
    get new_shipping_order_date_url
    assert_response :success
  end

  test "should create shipping_order_date" do
    assert_difference('ShippingOrderDate.count') do
      post shipping_order_dates_url, params: { shipping_order_date: { date_type: @shipping_order_date.date_type, date_value: @shipping_order_date.date_value, shipping_orders: @shipping_order_date.shipping_orders } }
    end

    assert_redirected_to shipping_order_date_url(ShippingOrderDate.last)
  end

  test "should show shipping_order_date" do
    get shipping_order_date_url(@shipping_order_date)
    assert_response :success
  end

  test "should get edit" do
    get edit_shipping_order_date_url(@shipping_order_date)
    assert_response :success
  end

  test "should update shipping_order_date" do
    patch shipping_order_date_url(@shipping_order_date), params: { shipping_order_date: { date_type: @shipping_order_date.date_type, date_value: @shipping_order_date.date_value, shipping_orders: @shipping_order_date.shipping_orders } }
    assert_redirected_to shipping_order_date_url(@shipping_order_date)
  end

  test "should destroy shipping_order_date" do
    assert_difference('ShippingOrderDate.count', -1) do
      delete shipping_order_date_url(@shipping_order_date)
    end

    assert_redirected_to shipping_order_dates_url
  end
end
