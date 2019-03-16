require 'test_helper'

class FlowReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @flow_report = flow_reports(:one)
  end

  test "should get index" do
    get flow_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_flow_report_url
    assert_response :success
  end

  test "should create flow_report" do
    assert_difference('FlowReport.count') do
      post flow_reports_url, params: { flow_report: { date: @flow_report.date, plant_id: @flow_report.plant_id } }
    end

    assert_redirected_to flow_report_url(FlowReport.last)
  end

  test "should show flow_report" do
    get flow_report_url(@flow_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_flow_report_url(@flow_report)
    assert_response :success
  end

  test "should update flow_report" do
    patch flow_report_url(@flow_report), params: { flow_report: { date: @flow_report.date, plant_id: @flow_report.plant_id } }
    assert_redirected_to flow_report_url(@flow_report)
  end

  test "should destroy flow_report" do
    assert_difference('FlowReport.count', -1) do
      delete flow_report_url(@flow_report)
    end

    assert_redirected_to flow_reports_url
  end
end
