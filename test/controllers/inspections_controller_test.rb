require 'test_helper'

class InspectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inspection = inspections(:one)
  end

  test "should get index" do
    get inspections_url
    assert_response :success
  end

  test "should get new" do
    get new_inspection_url
    assert_response :success
  end

  test "should create inspection" do
    assert_difference('Inspection.count') do
      post inspections_url, params: { inspection: { active: @inspection.active, bed_compaction_id: @inspection.bed_compaction_id, bida_comments: @inspection.bida_comments, birds: @inspection.birds, bod: @inspection.bod, cod: @inspection.cod, collection_bin_id: @inspection.collection_bin_id, ec: @inspection.ec, fly_id: @inspection.fly_id, noise_id: @inspection.noise_id, odor_id: @inspection.odor_id, piping_id: @inspection.piping_id, plant_id: @inspection.plant_id, plant_odor_description: @inspection.plant_odor_description, ponding_id: @inspection.ponding_id, pumps_comments: @inspection.pumps_comments, pumps_noise_description: @inspection.pumps_noise_description, pumps_psi: @inspection.pumps_psi, sample_comments: @inspection.sample_comments, screen_comments: @inspection.screen_comments, screen_id: @inspection.screen_id, sprinklers_head_id: @inspection.sprinklers_head_id, sprinklers_pressure_id: @inspection.sprinklers_pressure_id, summary_comments: @inspection.summary_comments, system_surface_id: @inspection.system_surface_id, tn: @inspection.tn, tp: @inspection.tp, tss: @inspection.tss, user_id: @inspection.user_id } }
    end

    assert_redirected_to inspection_url(Inspection.last)
  end

  test "should show inspection" do
    get inspection_url(@inspection)
    assert_response :success
  end

  test "should get edit" do
    get edit_inspection_url(@inspection)
    assert_response :success
  end

  test "should update inspection" do
    patch inspection_url(@inspection), params: { inspection: { active: @inspection.active, bed_compaction_id: @inspection.bed_compaction_id, bida_comments: @inspection.bida_comments, birds: @inspection.birds, bod: @inspection.bod, cod: @inspection.cod, collection_bin_id: @inspection.collection_bin_id, ec: @inspection.ec, fly_id: @inspection.fly_id, noise_id: @inspection.noise_id, odor_id: @inspection.odor_id, piping_id: @inspection.piping_id, plant_id: @inspection.plant_id, plant_odor_description: @inspection.plant_odor_description, ponding_id: @inspection.ponding_id, pumps_comments: @inspection.pumps_comments, pumps_noise_description: @inspection.pumps_noise_description, pumps_psi: @inspection.pumps_psi, sample_comments: @inspection.sample_comments, screen_comments: @inspection.screen_comments, screen_id: @inspection.screen_id, sprinklers_head_id: @inspection.sprinklers_head_id, sprinklers_pressure_id: @inspection.sprinklers_pressure_id, summary_comments: @inspection.summary_comments, system_surface_id: @inspection.system_surface_id, tn: @inspection.tn, tp: @inspection.tp, tss: @inspection.tss, user_id: @inspection.user_id } }
    assert_redirected_to inspection_url(@inspection)
  end

  test "should destroy inspection" do
    assert_difference('Inspection.count', -1) do
      delete inspection_url(@inspection)
    end

    assert_redirected_to inspections_url
  end
end
