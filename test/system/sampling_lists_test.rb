require "application_system_test_case"

class SamplingListsTest < ApplicationSystemTestCase
  setup do
    @sampling_list = sampling_lists(:one)
  end

  test "visiting the index" do
    visit sampling_lists_url
    assert_selector "h1", text: "Sampling Lists"
  end

  test "creating a Sampling list" do
    visit sampling_lists_url
    click_on "New Sampling List"

    fill_in "Access", with: @sampling_list.access_id
    fill_in "Frecuency", with: @sampling_list.frecuency_id
    fill_in "Per Cycle", with: @sampling_list.per_cycle
    fill_in "Plant", with: @sampling_list.plant_id
    click_on "Create Sampling list"

    assert_text "Sampling list was successfully created"
    click_on "Back"
  end

  test "updating a Sampling list" do
    visit sampling_lists_url
    click_on "Edit", match: :first

    fill_in "Access", with: @sampling_list.access_id
    fill_in "Frecuency", with: @sampling_list.frecuency_id
    fill_in "Per Cycle", with: @sampling_list.per_cycle
    fill_in "Plant", with: @sampling_list.plant_id
    click_on "Update Sampling list"

    assert_text "Sampling list was successfully updated"
    click_on "Back"
  end

  test "destroying a Sampling list" do
    visit sampling_lists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sampling list was successfully destroyed"
  end
end
