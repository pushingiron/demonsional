require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    @item = items(:one)
  end

  test "visiting the index" do
    visit items_url
    assert_selector "h1", text: "Items"
  end

  test "creating a Item" do
    visit items_url
    click_on "New Item"

    fill_in "Cube", with: @item.cube
    fill_in "Cube uom", with: @item.cube_uom
    fill_in "Description", with: @item.description
    fill_in "Freight class", with: @item.freight_class
    fill_in "Line number", with: @item.line_number
    fill_in "Quantity", with: @item.quantity
    fill_in "Quantity uom", with: @item.quantity_uom
    fill_in "Sequence", with: @item.sequence
    fill_in "Shipping orders", with: @item.shipping_orders
    fill_in "Type", with: @item.type
    fill_in "Weight", with: @item.weight
    fill_in "Weight uom", with: @item.weight_uom
    click_on "Create Item"

    assert_text "Item was successfully created"
    click_on "Back"
  end

  test "updating a Item" do
    visit items_url
    click_on "Edit", match: :first

    fill_in "Cube", with: @item.cube
    fill_in "Cube uom", with: @item.cube_uom
    fill_in "Description", with: @item.description
    fill_in "Freight class", with: @item.freight_class
    fill_in "Line number", with: @item.line_number
    fill_in "Quantity", with: @item.quantity
    fill_in "Quantity uom", with: @item.quantity_uom
    fill_in "Sequence", with: @item.sequence
    fill_in "Shipping orders", with: @item.shipping_orders
    fill_in "Type", with: @item.type
    fill_in "Weight", with: @item.weight
    fill_in "Weight uom", with: @item.weight_uom
    click_on "Update Item"

    assert_text "Item was successfully updated"
    click_on "Back"
  end

  test "destroying a Item" do
    visit items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Item was successfully destroyed"
  end
end
