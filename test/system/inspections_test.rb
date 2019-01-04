require "application_system_test_case"

class InspectionsTest < ApplicationSystemTestCase
  setup do
    @inspection = inspections(:one)
  end

  test "visiting the index" do
    visit inspections_url
    assert_selector "h1", text: "Inspections"
  end

  test "creating a Inspection" do
    visit inspections_url
    click_on "New Inspection"

    fill_in "Active", with: @inspection.active
    fill_in "Bed Compaction", with: @inspection.bed_compaction_id
    fill_in "Bida Comments", with: @inspection.bida_comments
    fill_in "Birds", with: @inspection.birds
    fill_in "Bod", with: @inspection.bod
    fill_in "Cod", with: @inspection.cod
    fill_in "Collection Bin", with: @inspection.collection_bin_id
    fill_in "Ec", with: @inspection.ec
    fill_in "Fly", with: @inspection.fly_id
    fill_in "Noise", with: @inspection.noise_id
    fill_in "Odor", with: @inspection.odor_id
    fill_in "Piping", with: @inspection.piping_id
    fill_in "Plant", with: @inspection.plant_id
    fill_in "Plant Odor Description", with: @inspection.plant_odor_description
    fill_in "Ponding", with: @inspection.ponding_id
    fill_in "Pumps Comments", with: @inspection.pumps_comments
    fill_in "Pumps Noise Description", with: @inspection.pumps_noise_description
    fill_in "Pumps Psi", with: @inspection.pumps_psi
    fill_in "Sample Comments", with: @inspection.sample_comments
    fill_in "Screen Comments", with: @inspection.screen_comments
    fill_in "Screen", with: @inspection.screen_id
    fill_in "Sprinklers Head", with: @inspection.sprinklers_head_id
    fill_in "Sprinklers Pressure", with: @inspection.sprinklers_pressure_id
    fill_in "Summary Comments", with: @inspection.summary_comments
    fill_in "System Surface", with: @inspection.system_surface_id
    fill_in "Tn", with: @inspection.tn
    fill_in "Tp", with: @inspection.tp
    fill_in "Tss", with: @inspection.tss
    fill_in "User", with: @inspection.user_id
    click_on "Create Inspection"

    assert_text "Inspection was successfully created"
    click_on "Back"
  end

  test "updating a Inspection" do
    visit inspections_url
    click_on "Edit", match: :first

    fill_in "Active", with: @inspection.active
    fill_in "Bed Compaction", with: @inspection.bed_compaction_id
    fill_in "Bida Comments", with: @inspection.bida_comments
    fill_in "Birds", with: @inspection.birds
    fill_in "Bod", with: @inspection.bod
    fill_in "Cod", with: @inspection.cod
    fill_in "Collection Bin", with: @inspection.collection_bin_id
    fill_in "Ec", with: @inspection.ec
    fill_in "Fly", with: @inspection.fly_id
    fill_in "Noise", with: @inspection.noise_id
    fill_in "Odor", with: @inspection.odor_id
    fill_in "Piping", with: @inspection.piping_id
    fill_in "Plant", with: @inspection.plant_id
    fill_in "Plant Odor Description", with: @inspection.plant_odor_description
    fill_in "Ponding", with: @inspection.ponding_id
    fill_in "Pumps Comments", with: @inspection.pumps_comments
    fill_in "Pumps Noise Description", with: @inspection.pumps_noise_description
    fill_in "Pumps Psi", with: @inspection.pumps_psi
    fill_in "Sample Comments", with: @inspection.sample_comments
    fill_in "Screen Comments", with: @inspection.screen_comments
    fill_in "Screen", with: @inspection.screen_id
    fill_in "Sprinklers Head", with: @inspection.sprinklers_head_id
    fill_in "Sprinklers Pressure", with: @inspection.sprinklers_pressure_id
    fill_in "Summary Comments", with: @inspection.summary_comments
    fill_in "System Surface", with: @inspection.system_surface_id
    fill_in "Tn", with: @inspection.tn
    fill_in "Tp", with: @inspection.tp
    fill_in "Tss", with: @inspection.tss
    fill_in "User", with: @inspection.user_id
    click_on "Update Inspection"

    assert_text "Inspection was successfully updated"
    click_on "Back"
  end

  test "destroying a Inspection" do
    visit inspections_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Inspection was successfully destroyed"
  end
end
