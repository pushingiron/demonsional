require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = locations(:one)
  end

  test "should get index" do
    get locations_url
    assert_response :success
  end

  test "should get new" do
    get new_location_url
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post locations_url, params: { location: { address1: @location.address1, address2: @location.address2, city: @location.city, comments: @location.comments, country: @location.country, earliest_appt: @location.earliest_appt, geo: @location.geo, latest_appt: @location.latest_appt, loc_code: @location.loc_code, name: @location.name, postal: @location.postal, reference: @location.reference, residential: @location.residential, state: @location.state } }
    end

    assert_redirected_to location_url(Location.last)
  end

  test "should show location" do
    get location_url(@location)
    assert_response :success
  end

  test "should get edit" do
    get edit_location_url(@location)
    assert_response :success
  end

  test "should update location" do
    patch location_url(@location), params: { location: { address1: @location.address1, address2: @location.address2, city: @location.city, comments: @location.comments, country: @location.country, earliest_appt: @location.earliest_appt, geo: @location.geo, latest_appt: @location.latest_appt, loc_code: @location.loc_code, name: @location.name, postal: @location.postal, reference: @location.reference, residential: @location.residential, state: @location.state } }
    assert_redirected_to location_url(@location)
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete location_url(@location)
    end

    assert_redirected_to locations_url
  end
end
