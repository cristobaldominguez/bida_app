require 'test_helper'

class LogStandardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @log_standard = log_standards(:one)
  end

  test "should get index" do
    get log_standards_url
    assert_response :success
  end

  test "should get new" do
    get new_log_standard_url
    assert_response :success
  end

  test "should create log_standard" do
    assert_difference('LogStandard.count') do
      post log_standards_url, params: { log_standard: { active: @log_standard.active, cycle: @log_standard.cycle, frecuency_id: @log_standard.frecuency_id, plant_id: @log_standard.plant_id, responsible: @log_standard.responsible, task_id: @log_standard.task_id } }
    end

    assert_redirected_to log_standard_url(LogStandard.last)
  end

  test "should show log_standard" do
    get log_standard_url(@log_standard)
    assert_response :success
  end

  test "should get edit" do
    get edit_log_standard_url(@log_standard)
    assert_response :success
  end

  test "should update log_standard" do
    patch log_standard_url(@log_standard), params: { log_standard: { active: @log_standard.active, cycle: @log_standard.cycle, frecuency_id: @log_standard.frecuency_id, plant_id: @log_standard.plant_id, responsible: @log_standard.responsible, task_id: @log_standard.task_id } }
    assert_redirected_to log_standard_url(@log_standard)
  end

  test "should destroy log_standard" do
    assert_difference('LogStandard.count', -1) do
      delete log_standard_url(@log_standard)
    end

    assert_redirected_to log_standards_url
  end
end
