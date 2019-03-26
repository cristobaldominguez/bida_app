require "application_system_test_case"

class FlowReportsTest < ApplicationSystemTestCase
  setup do
    @flow_report = flow_reports(:one)
  end

  test "visiting the index" do
    visit flow_reports_url
    assert_selector "h1", text: "Flow Reports"
  end

  test "creating a Flow report" do
    visit flow_reports_url
    click_on "New Flow Report"

    fill_in "Date", with: @flow_report.date
    fill_in "Plant", with: @flow_report.plant_id
    click_on "Create Flow report"

    assert_text "Flow report was successfully created"
    click_on "Back"
  end

  test "updating a Flow report" do
    visit flow_reports_url
    click_on "Edit", match: :first

    fill_in "Date", with: @flow_report.date
    fill_in "Plant", with: @flow_report.plant_id
    click_on "Update Flow report"

    assert_text "Flow report was successfully updated"
    click_on "Back"
  end

  test "destroying a Flow report" do
    visit flow_reports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Flow report was successfully destroyed"
  end
end
