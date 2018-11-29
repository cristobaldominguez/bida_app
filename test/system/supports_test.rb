require "application_system_test_case"

class SupportsTest < ApplicationSystemTestCase
  setup do
    @support = supports(:one)
  end

  test "visiting the index" do
    visit supports_url
    assert_selector "h1", text: "Supports"
  end

  test "creating a Support" do
    visit supports_url
    click_on "New Support"

    fill_in "Active", with: @support.active
    fill_in "Client Onsite", with: @support.client_onsite
    fill_in "End Date", with: @support.end_date
    fill_in "Name Client Onsite", with: @support.name_client_onsite
    fill_in "Number", with: @support.number
    fill_in "Start Date", with: @support.start_date
    click_on "Create Support"

    assert_text "Support was successfully created"
    click_on "Back"
  end

  test "updating a Support" do
    visit supports_url
    click_on "Edit", match: :first

    fill_in "Active", with: @support.active
    fill_in "Client Onsite", with: @support.client_onsite
    fill_in "End Date", with: @support.end_date
    fill_in "Name Client Onsite", with: @support.name_client_onsite
    fill_in "Number", with: @support.number
    fill_in "Start Date", with: @support.start_date
    click_on "Update Support"

    assert_text "Support was successfully updated"
    click_on "Back"
  end

  test "destroying a Support" do
    visit supports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Support was successfully destroyed"
  end
end
