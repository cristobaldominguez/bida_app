require "application_system_test_case"

class LogbooksTest < ApplicationSystemTestCase
  setup do
    @logbook = logbooks(:one)
  end

  test "visiting the index" do
    visit logbooks_url
    assert_selector "h1", text: "Logbooks"
  end

  test "creating a Logbook" do
    visit logbooks_url
    click_on "New Logbook"

    fill_in "Plant", with: @logbook.plant_id
    click_on "Create Logbook"

    assert_text "Logbook was successfully created"
    click_on "Back"
  end

  test "updating a Logbook" do
    visit logbooks_url
    click_on "Edit", match: :first

    fill_in "Plant", with: @logbook.plant_id
    click_on "Update Logbook"

    assert_text "Logbook was successfully updated"
    click_on "Back"
  end

  test "destroying a Logbook" do
    visit logbooks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Logbook was successfully destroyed"
  end
end
