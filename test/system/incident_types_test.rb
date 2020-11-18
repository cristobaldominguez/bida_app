require "application_system_test_case"

class IncidentTypesTest < ApplicationSystemTestCase
  setup do
    @incident_type = incident_types(:one)
  end

  test "visiting the index" do
    visit incident_types_url
    assert_selector "h1", text: "Incident Types"
  end

  test "creating a Incident type" do
    visit incident_types_url
    click_on "New Incident Type"

    click_on "Create Incident type"

    assert_text "Incident type was successfully created"
    click_on "Back"
  end

  test "updating a Incident type" do
    visit incident_types_url
    click_on "Edit", match: :first

    click_on "Update Incident type"

    assert_text "Incident type was successfully updated"
    click_on "Back"
  end

  test "destroying a Incident type" do
    visit incident_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Incident type was successfully destroyed"
  end
end
