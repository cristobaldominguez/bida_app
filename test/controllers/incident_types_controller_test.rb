require 'test_helper'

class IncidentTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incident_type = incident_types(:one)
  end

  test "should get index" do
    get incident_types_url
    assert_response :success
  end

  test "should get new" do
    get new_incident_type_url
    assert_response :success
  end

  test "should create incident_type" do
    assert_difference('IncidentType.count') do
      post incident_types_url, params: { incident_type: {  } }
    end

    assert_redirected_to incident_type_url(IncidentType.last)
  end

  test "should show incident_type" do
    get incident_type_url(@incident_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_incident_type_url(@incident_type)
    assert_response :success
  end

  test "should update incident_type" do
    patch incident_type_url(@incident_type), params: { incident_type: {  } }
    assert_redirected_to incident_type_url(@incident_type)
  end

  test "should destroy incident_type" do
    assert_difference('IncidentType.count', -1) do
      delete incident_type_url(@incident_type)
    end

    assert_redirected_to incident_types_url
  end
end
