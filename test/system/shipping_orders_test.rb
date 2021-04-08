require "application_system_test_case"

class ShippingOrdersTest < ApplicationSystemTestCase
  setup do
    @shipping_order = shipping_orders(:one)
  end

  test "visiting the index" do
    visit shipping_orders_url
    assert_selector "h1", text: "Shipping Orders"
  end

  test "creating a Shipping order" do
    visit shipping_orders_url
    click_on "New Shipping Order"

    fill_in "Cust acct num", with: @shipping_order.cust_acct_num
    fill_in "Payment method", with: @shipping_order.payment_method
    fill_in "Reference", with: @shipping_order.reference
    click_on "Create Shipping order"

    assert_text "Shipping order was successfully created"
    click_on "Back"
  end

  test "updating a Shipping order" do
    visit shipping_orders_url
    click_on "Edit", match: :first

    fill_in "Cust acct num", with: @shipping_order.cust_acct_num
    fill_in "Payment method", with: @shipping_order.payment_method
    fill_in "Reference", with: @shipping_order.reference
    click_on "Update Shipping order"

    assert_text "Shipping order was successfully updated"
    click_on "Back"
  end

  test "destroying a Shipping order" do
    visit shipping_orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shipping order was successfully destroyed"
  end
end
