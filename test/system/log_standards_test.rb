require "application_system_test_case"

class LogStandardsTest < ApplicationSystemTestCase
  setup do
    @log_standard = log_standards(:one)
  end

  test "visiting the index" do
    visit log_standards_url
    assert_selector "h1", text: "Log Standards"
  end

  test "creating a Log standard" do
    visit log_standards_url
    click_on "New Log Standard"

    fill_in "Active", with: @log_standard.active
    fill_in "Cycle", with: @log_standard.cycle
    fill_in "Frecuency", with: @log_standard.frecuency_id
    fill_in "Plant", with: @log_standard.plant_id
    fill_in "Responsible", with: @log_standard.responsible
    fill_in "Task", with: @log_standard.task_id
    click_on "Create Log standard"

    assert_text "Log standard was successfully created"
    click_on "Back"
  end

  test "updating a Log standard" do
    visit log_standards_url
    click_on "Edit", match: :first

    fill_in "Active", with: @log_standard.active
    fill_in "Cycle", with: @log_standard.cycle
    fill_in "Frecuency", with: @log_standard.frecuency_id
    fill_in "Plant", with: @log_standard.plant_id
    fill_in "Responsible", with: @log_standard.responsible
    fill_in "Task", with: @log_standard.task_id
    click_on "Update Log standard"

    assert_text "Log standard was successfully updated"
    click_on "Back"
  end

  test "destroying a Log standard" do
    visit log_standards_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Log standard was successfully destroyed"
  end
end
