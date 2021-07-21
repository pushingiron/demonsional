require "application_system_test_case"

class RatesTest < ApplicationSystemTestCase
  setup do
    @rate = rates(:one)
  end

  test "visiting the index" do
    visit rates_url
    assert_selector "h1", text: "Rates"
  end

  test "creating a Rate" do
    visit rates_url
    click_on "New Rate"

    fill_in "Accessorial1 calc", with: @rate.accessorial1_calc
    fill_in "Accessorial1 field", with: @rate.accessorial1_field
    fill_in "Accessorial1 rate", with: @rate.accessorial1_rate
    fill_in "Break 1 field", with: @rate.break_1_field
    fill_in "Break 1 max", with: @rate.break_1_max
    fill_in "Break 1 min", with: @rate.break_1_min
    fill_in "Contract", with: @rate.contract_id
    fill_in "From city", with: @rate.from_city
    fill_in "From country", with: @rate.from_country
    fill_in "From loccode", with: @rate.from_loccode
    fill_in "From state", with: @rate.from_state
    fill_in "From zip", with: @rate.from_zip
    fill_in "Lane calc", with: @rate.lane_calc
    fill_in "Mode", with: @rate.mode
    fill_in "Rate", with: @rate.rate
    fill_in "Rate calc", with: @rate.rate_calc
    fill_in "Rate field", with: @rate.rate_field
    fill_in "Scac", with: @rate.scac
    fill_in "Service", with: @rate.service
    fill_in "To city", with: @rate.to_city
    fill_in "To country", with: @rate.to_country
    fill_in "To loccode", with: @rate.to_loccode
    fill_in "To state", with: @rate.to_state
    fill_in "To zip", with: @rate.to_zip
    fill_in "Total min", with: @rate.total_min
    fill_in "User", with: @rate.user_id
    click_on "Create Rate"

    assert_text "Rate was successfully created"
    click_on "Back"
  end

  test "updating a Rate" do
    visit rates_url
    click_on "Edit", match: :first

    fill_in "Accessorial1 calc", with: @rate.accessorial1_calc
    fill_in "Accessorial1 field", with: @rate.accessorial1_field
    fill_in "Accessorial1 rate", with: @rate.accessorial1_rate
    fill_in "Break 1 field", with: @rate.break_1_field
    fill_in "Break 1 max", with: @rate.break_1_max
    fill_in "Break 1 min", with: @rate.break_1_min
    fill_in "Contract", with: @rate.contract_id
    fill_in "From city", with: @rate.from_city
    fill_in "From country", with: @rate.from_country
    fill_in "From loccode", with: @rate.from_loccode
    fill_in "From state", with: @rate.from_state
    fill_in "From zip", with: @rate.from_zip
    fill_in "Lane calc", with: @rate.lane_calc
    fill_in "Mode", with: @rate.mode
    fill_in "Rate", with: @rate.rate
    fill_in "Rate calc", with: @rate.rate_calc
    fill_in "Rate field", with: @rate.rate_field
    fill_in "Scac", with: @rate.scac
    fill_in "Service", with: @rate.service
    fill_in "To city", with: @rate.to_city
    fill_in "To country", with: @rate.to_country
    fill_in "To loccode", with: @rate.to_loccode
    fill_in "To state", with: @rate.to_state
    fill_in "To zip", with: @rate.to_zip
    fill_in "Total min", with: @rate.total_min
    fill_in "User", with: @rate.user_id
    click_on "Update Rate"

    assert_text "Rate was successfully updated"
    click_on "Back"
  end

  test "destroying a Rate" do
    visit rates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Rate was successfully destroyed"
  end
end
