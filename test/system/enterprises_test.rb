require "application_system_test_case"

class EnterprisesTest < ApplicationSystemTestCase
  setup do
    @enterprise = enterprises(:one)
  end

  test "visiting the index" do
    visit enterprises_url
    assert_selector "h1", text: "Enterprises"
  end

  test "creating a Enterprise" do
    visit enterprises_url
    click_on "New Enterprise"

    check "Active" if @enterprise.active
    fill_in "Address 1", with: @enterprise.address_1
    fill_in "Address 2", with: @enterprise.address_2
    fill_in "City", with: @enterprise.city
    fill_in "Country", with: @enterprise.country
    fill_in "Location code", with: @enterprise.location_code
    fill_in "Location name", with: @enterprise.location_name
    fill_in "New acct", with: @enterprise.new_acct
    fill_in "New name", with: @enterprise.new_name
    fill_in "Parent", with: @enterprise.parent
    fill_in "Postal", with: @enterprise.postal
    fill_in "State", with: @enterprise.state
    fill_in "User", with: @enterprise.user_id
    click_on "Create Enterprise"

    assert_text "Enterprise was successfully created"
    click_on "Back"
  end

  test "updating a Enterprise" do
    visit enterprises_url
    click_on "Edit", match: :first

    check "Active" if @enterprise.active
    fill_in "Address 1", with: @enterprise.address_1
    fill_in "Address 2", with: @enterprise.address_2
    fill_in "City", with: @enterprise.city
    fill_in "Country", with: @enterprise.country
    fill_in "Location code", with: @enterprise.location_code
    fill_in "Location name", with: @enterprise.location_name
    fill_in "New acct", with: @enterprise.new_acct
    fill_in "New name", with: @enterprise.new_name
    fill_in "Parent", with: @enterprise.parent
    fill_in "Postal", with: @enterprise.postal
    fill_in "State", with: @enterprise.state
    fill_in "User", with: @enterprise.user_id
    click_on "Update Enterprise"

    assert_text "Enterprise was successfully updated"
    click_on "Back"
  end

  test "destroying a Enterprise" do
    visit enterprises_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Enterprise was successfully destroyed"
  end
end
