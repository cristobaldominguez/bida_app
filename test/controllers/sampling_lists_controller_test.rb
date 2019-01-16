require 'test_helper'

class SamplingListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sampling_list = sampling_lists(:one)
  end

  test "should get index" do
    get sampling_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_sampling_list_url
    assert_response :success
  end

  test "should create sampling_list" do
    assert_difference('SamplingList.count') do
      post sampling_lists_url, params: { sampling_list: { access_id: @sampling_list.access_id, frecuency_id: @sampling_list.frecuency_id, per_cycle: @sampling_list.per_cycle, plant_id: @sampling_list.plant_id } }
    end

    assert_redirected_to sampling_list_url(SamplingList.last)
  end

  test "should show sampling_list" do
    get sampling_list_url(@sampling_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_sampling_list_url(@sampling_list)
    assert_response :success
  end

  test "should update sampling_list" do
    patch sampling_list_url(@sampling_list), params: { sampling_list: { access_id: @sampling_list.access_id, frecuency_id: @sampling_list.frecuency_id, per_cycle: @sampling_list.per_cycle, plant_id: @sampling_list.plant_id } }
    assert_redirected_to sampling_list_url(@sampling_list)
  end

  test "should destroy sampling_list" do
    assert_difference('SamplingList.count', -1) do
      delete sampling_list_url(@sampling_list)
    end

    assert_redirected_to sampling_lists_url
  end
end
