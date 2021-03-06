require "application_system_test_case"

class LocationsTest < ApplicationSystemTestCase
  setup do
    @location = locations(:one)
  end

  test "visiting the index" do
    visit locations_url
    assert_selector "h1", text: "Locations"
  end

  test "creating a Location" do
    visit locations_url
    click_on "New Location"

    fill_in "Address1", with: @location.address1
    fill_in "Address2", with: @location.address2
    fill_in "City", with: @location.city
    fill_in "Comments", with: @location.comments
    fill_in "Country", with: @location.country
    fill_in "Earliest appt", with: @location.earliest_appt
    fill_in "Geo", with: @location.geo
    fill_in "Latest appt", with: @location.latest_appt
    fill_in "Loc code", with: @location.loc_code
    fill_in "Name", with: @location.name
    fill_in "Postal", with: @location.postal
    fill_in "Reference", with: @location.reference
    check "Residential" if @location.residential
    fill_in "State", with: @location.state
    click_on "Create Location"

    assert_text "Location was successfully created"
    click_on "Back"
  end

  test "updating a Location" do
    visit locations_url
    click_on "Edit", match: :first

    fill_in "Address1", with: @location.address1
    fill_in "Address2", with: @location.address2
    fill_in "City", with: @location.city
    fill_in "Comments", with: @location.comments
    fill_in "Country", with: @location.country
    fill_in "Earliest appt", with: @location.earliest_appt
    fill_in "Geo", with: @location.geo
    fill_in "Latest appt", with: @location.latest_appt
    fill_in "Loc code", with: @location.loc_code
    fill_in "Name", with: @location.name
    fill_in "Postal", with: @location.postal
    fill_in "Reference", with: @location.reference
    check "Residential" if @location.residential
    fill_in "State", with: @location.state
    click_on "Update Location"

    assert_text "Location was successfully updated"
    click_on "Back"
  end

  test "destroying a Location" do
    visit locations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Location was successfully destroyed"
  end
end
