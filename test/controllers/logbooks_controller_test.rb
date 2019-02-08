require 'test_helper'

class LogbooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @logbook = logbooks(:one)
  end

  test "should get index" do
    get logbooks_url
    assert_response :success
  end

  test "should get new" do
    get new_logbook_url
    assert_response :success
  end

  test "should create logbook" do
    assert_difference('Logbook.count') do
      post logbooks_url, params: { logbook: { plant_id: @logbook.plant_id } }
    end

    assert_redirected_to logbook_url(Logbook.last)
  end

  test "should show logbook" do
    get logbook_url(@logbook)
    assert_response :success
  end

  test "should get edit" do
    get edit_logbook_url(@logbook)
    assert_response :success
  end

  test "should update logbook" do
    patch logbook_url(@logbook), params: { logbook: { plant_id: @logbook.plant_id } }
    assert_redirected_to logbook_url(@logbook)
  end

  test "should destroy logbook" do
    assert_difference('Logbook.count', -1) do
      delete logbook_url(@logbook)
    end

    assert_redirected_to logbooks_url
  end
end
