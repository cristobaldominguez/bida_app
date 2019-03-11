require 'test_helper'

class GraphStandardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @graph_standard = graph_standards(:one)
  end

  test "should get index" do
    get graph_standards_url
    assert_response :success
  end

  test "should get new" do
    get new_graph_standard_url
    assert_response :success
  end

  test "should create graph_standard" do
    assert_difference('GraphStandard.count') do
      post graph_standards_url, params: { graph_standard: { active: @graph_standard.active, chart_id: @graph_standard.chart_id, plant_id: @graph_standard.plant_id, show: @graph_standard.show } }
    end

    assert_redirected_to graph_standard_url(GraphStandard.last)
  end

  test "should show graph_standard" do
    get graph_standard_url(@graph_standard)
    assert_response :success
  end

  test "should get edit" do
    get edit_graph_standard_url(@graph_standard)
    assert_response :success
  end

  test "should update graph_standard" do
    patch graph_standard_url(@graph_standard), params: { graph_standard: { active: @graph_standard.active, chart_id: @graph_standard.chart_id, plant_id: @graph_standard.plant_id, show: @graph_standard.show } }
    assert_redirected_to graph_standard_url(@graph_standard)
  end

  test "should destroy graph_standard" do
    assert_difference('GraphStandard.count', -1) do
      delete graph_standard_url(@graph_standard)
    end

    assert_redirected_to graph_standards_url
  end
end
