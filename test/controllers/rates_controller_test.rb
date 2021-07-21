require "test_helper"

class RatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rate = rates(:one)
  end

  test "should get index" do
    get rates_url
    assert_response :success
  end

  test "should get new" do
    get new_rate_url
    assert_response :success
  end

  test "should create rate" do
    assert_difference('Rate.count') do
      post rates_url, params: { rate: { accessorial1_calc: @rate.accessorial1_calc, accessorial1_field: @rate.accessorial1_field, accessorial1_rate: @rate.accessorial1_rate, break_1_field: @rate.break_1_field, break_1_max: @rate.break_1_max, break_1_min: @rate.break_1_min, contract_id: @rate.contract_id, from_city: @rate.from_city, from_country: @rate.from_country, from_loccode: @rate.from_loccode, from_state: @rate.from_state, from_zip: @rate.from_zip, lane_calc: @rate.lane_calc, mode: @rate.mode, rate: @rate.rate, rate_calc: @rate.rate_calc, rate_field: @rate.rate_field, scac: @rate.scac, service: @rate.service, to_city: @rate.to_city, to_country: @rate.to_country, to_loccode: @rate.to_loccode, to_state: @rate.to_state, to_zip: @rate.to_zip, total_min: @rate.total_min, user_id: @rate.user_id } }
    end

    assert_redirected_to rate_url(Rate.last)
  end

  test "should show rate" do
    get rate_url(@rate)
    assert_response :success
  end

  test "should get edit" do
    get edit_rate_url(@rate)
    assert_response :success
  end

  test "should update rate" do
    patch rate_url(@rate), params: { rate: { accessorial1_calc: @rate.accessorial1_calc, accessorial1_field: @rate.accessorial1_field, accessorial1_rate: @rate.accessorial1_rate, break_1_field: @rate.break_1_field, break_1_max: @rate.break_1_max, break_1_min: @rate.break_1_min, contract_id: @rate.contract_id, from_city: @rate.from_city, from_country: @rate.from_country, from_loccode: @rate.from_loccode, from_state: @rate.from_state, from_zip: @rate.from_zip, lane_calc: @rate.lane_calc, mode: @rate.mode, rate: @rate.rate, rate_calc: @rate.rate_calc, rate_field: @rate.rate_field, scac: @rate.scac, service: @rate.service, to_city: @rate.to_city, to_country: @rate.to_country, to_loccode: @rate.to_loccode, to_state: @rate.to_state, to_zip: @rate.to_zip, total_min: @rate.total_min, user_id: @rate.user_id } }
    assert_redirected_to rate_url(@rate)
  end

  test "should destroy rate" do
    assert_difference('Rate.count', -1) do
      delete rate_url(@rate)
    end

    assert_redirected_to rates_url
  end
end
