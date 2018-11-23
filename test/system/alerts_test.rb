require "application_system_test_case"

class AlertsTest < ApplicationSystemTestCase
  setup do
    @alert = alerts(:one)
  end

  test "visiting the index" do
    visit alerts_url
    assert_selector "h1", text: "Alerts"
  end

  test "creating a Alert" do
    visit alerts_url
    click_on "New Alert"

    fill_in "Incident Description", with: @alert.incident_description
    fill_in "Incident", with: @alert.incident_id
    fill_in "Incident Resolution", with: @alert.incident_resolution
    fill_in "Negative Impact", with: @alert.negative_impact
    fill_in "Plant", with: @alert.plant_id
    fill_in "Priority", with: @alert.priority_id
    fill_in "Solution", with: @alert.solution
    fill_in "Solution Target Date", with: @alert.solution_target_date
    fill_in "Status", with: @alert.status_id
    fill_in "Technician Hours Required", with: @alert.technician_hours_required
    fill_in "User", with: @alert.user_id
    click_on "Create Alert"

    assert_text "Alert was successfully created"
    click_on "Back"
  end

  test "updating a Alert" do
    visit alerts_url
    click_on "Edit", match: :first

    fill_in "Incident Description", with: @alert.incident_description
    fill_in "Incident", with: @alert.incident_id
    fill_in "Incident Resolution", with: @alert.incident_resolution
    fill_in "Negative Impact", with: @alert.negative_impact
    fill_in "Plant", with: @alert.plant_id
    fill_in "Priority", with: @alert.priority_id
    fill_in "Solution", with: @alert.solution
    fill_in "Solution Target Date", with: @alert.solution_target_date
    fill_in "Status", with: @alert.status_id
    fill_in "Technician Hours Required", with: @alert.technician_hours_required
    fill_in "User", with: @alert.user_id
    click_on "Update Alert"

    assert_text "Alert was successfully updated"
    click_on "Back"
  end

  test "destroying a Alert" do
    visit alerts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Alert was successfully destroyed"
  end
end
