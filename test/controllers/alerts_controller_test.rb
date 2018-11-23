require 'test_helper'

class AlertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alert = alerts(:one)
  end

  test "should get index" do
    get alerts_url
    assert_response :success
  end

  test "should get new" do
    get new_alert_url
    assert_response :success
  end

  test "should create alert" do
    assert_difference('Alert.count') do
      post alerts_url, params: { alert: { incident_description: @alert.incident_description, incident_id: @alert.incident_id, incident_resolution: @alert.incident_resolution, negative_impact: @alert.negative_impact, plant_id: @alert.plant_id, priority_id: @alert.priority_id, solution: @alert.solution, solution_target_date: @alert.solution_target_date, status_id: @alert.status_id, technician_hours_required: @alert.technician_hours_required, user_id: @alert.user_id } }
    end

    assert_redirected_to alert_url(Alert.last)
  end

  test "should show alert" do
    get alert_url(@alert)
    assert_response :success
  end

  test "should get edit" do
    get edit_alert_url(@alert)
    assert_response :success
  end

  test "should update alert" do
    patch alert_url(@alert), params: { alert: { incident_description: @alert.incident_description, incident_id: @alert.incident_id, incident_resolution: @alert.incident_resolution, negative_impact: @alert.negative_impact, plant_id: @alert.plant_id, priority_id: @alert.priority_id, solution: @alert.solution, solution_target_date: @alert.solution_target_date, status_id: @alert.status_id, technician_hours_required: @alert.technician_hours_required, user_id: @alert.user_id } }
    assert_redirected_to alert_url(@alert)
  end

  test "should destroy alert" do
    assert_difference('Alert.count', -1) do
      delete alert_url(@alert)
    end

    assert_redirected_to alerts_url
  end
end
