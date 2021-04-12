require "application_system_test_case"

class ShippingOrderDatesTest < ApplicationSystemTestCase
  setup do
    @shipping_order_date = shipping_order_dates(:one)
  end

  test "visiting the index" do
    visit shipping_order_dates_url
    assert_selector "h1", text: "Shipping Order Dates"
  end

  test "creating a Shipping order date" do
    visit shipping_order_dates_url
    click_on "New Shipping Order Date"

    fill_in "Date type", with: @shipping_order_date.date_type
    fill_in "Date value", with: @shipping_order_date.date_value
    fill_in "Shipping orders", with: @shipping_order_date.shipping_orders
    click_on "Create Shipping order date"

    assert_text "Shipping order date was successfully created"
    click_on "Back"
  end

  test "updating a Shipping order date" do
    visit shipping_order_dates_url
    click_on "Edit", match: :first

    fill_in "Date type", with: @shipping_order_date.date_type
    fill_in "Date value", with: @shipping_order_date.date_value
    fill_in "Shipping orders", with: @shipping_order_date.shipping_orders
    click_on "Update Shipping order date"

    assert_text "Shipping order date was successfully updated"
    click_on "Back"
  end

  test "destroying a Shipping order date" do
    visit shipping_order_dates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shipping order date was successfully destroyed"
  end
end
