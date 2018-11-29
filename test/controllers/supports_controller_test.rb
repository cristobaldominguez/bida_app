require 'test_helper'

class SupportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @support = supports(:one)
  end

  test "should get index" do
    get supports_url
    assert_response :success
  end

  test "should get new" do
    get new_support_url
    assert_response :success
  end

  test "should create support" do
    assert_difference('Support.count') do
      post supports_url, params: { support: { active: @support.active, client_onsite: @support.client_onsite, end_date: @support.end_date, name_client_onsite: @support.name_client_onsite, number: @support.number, start_date: @support.start_date } }
    end

    assert_redirected_to support_url(Support.last)
  end

  test "should show support" do
    get support_url(@support)
    assert_response :success
  end

  test "should get edit" do
    get edit_support_url(@support)
    assert_response :success
  end

  test "should update support" do
    patch support_url(@support), params: { support: { active: @support.active, client_onsite: @support.client_onsite, end_date: @support.end_date, name_client_onsite: @support.name_client_onsite, number: @support.number, start_date: @support.start_date } }
    assert_redirected_to support_url(@support)
  end

  test "should destroy support" do
    assert_difference('Support.count', -1) do
      delete support_url(@support)
    end

    assert_redirected_to supports_url
  end
end
