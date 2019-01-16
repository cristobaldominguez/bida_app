require 'test_helper'

class BoundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bound = bounds(:one)
  end

  test "should get index" do
    get bounds_url
    assert_response :success
  end

  test "should get new" do
    get new_bound_url
    assert_response :success
  end

  test "should create bound" do
    assert_difference('Bound.count') do
      post bounds_url, params: { bound: { active: @bound.active, from: @bound.from, outlet_id: @bound.outlet_id, standard_id: @bound.standard_id, to: @bound.to } }
    end

    assert_redirected_to bound_url(Bound.last)
  end

  test "should show bound" do
    get bound_url(@bound)
    assert_response :success
  end

  test "should get edit" do
    get edit_bound_url(@bound)
    assert_response :success
  end

  test "should update bound" do
    patch bound_url(@bound), params: { bound: { active: @bound.active, from: @bound.from, outlet_id: @bound.outlet_id, standard_id: @bound.standard_id, to: @bound.to } }
    assert_redirected_to bound_url(@bound)
  end

  test "should destroy bound" do
    assert_difference('Bound.count', -1) do
      delete bound_url(@bound)
    end

    assert_redirected_to bounds_url
  end
end
