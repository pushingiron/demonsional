require "test_helper"

class ShippingOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipping_order = shipping_orders(:one)
  end

  test "should get index" do
    get shipping_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_shipping_order_url
    assert_response :success
  end

  test "should create shipping_order" do
    assert_difference('ShippingOrder.count') do
      post shipping_orders_url, params: { shipping_order: { cust_acct_num: @shipping_order.cust_acct_num, payment_method: @shipping_order.payment_method, reference: @shipping_order.reference } }
    end

    assert_redirected_to shipping_order_url(ShippingOrder.last)
  end

  test "should show shipping_order" do
    get shipping_order_url(@shipping_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_shipping_order_url(@shipping_order)
    assert_response :success
  end

  test "should update shipping_order" do
    patch shipping_order_url(@shipping_order), params: { shipping_order: { cust_acct_num: @shipping_order.cust_acct_num, payment_method: @shipping_order.payment_method, reference: @shipping_order.reference } }
    assert_redirected_to shipping_order_url(@shipping_order)
  end

  test "should destroy shipping_order" do
    assert_difference('ShippingOrder.count', -1) do
      delete shipping_order_url(@shipping_order)
    end

    assert_redirected_to shipping_orders_url
  end
end
