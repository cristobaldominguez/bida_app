require "application_system_test_case"

class BoundsTest < ApplicationSystemTestCase
  setup do
    @bound = bounds(:one)
  end

  test "visiting the index" do
    visit bounds_url
    assert_selector "h1", text: "Bounds"
  end

  test "creating a Bound" do
    visit bounds_url
    click_on "New Bound"

    fill_in "Active", with: @bound.active
    fill_in "From", with: @bound.from
    fill_in "Outlet", with: @bound.outlet_id
    fill_in "Standard", with: @bound.standard_id
    fill_in "To", with: @bound.to
    click_on "Create Bound"

    assert_text "Bound was successfully created"
    click_on "Back"
  end

  test "updating a Bound" do
    visit bounds_url
    click_on "Edit", match: :first

    fill_in "Active", with: @bound.active
    fill_in "From", with: @bound.from
    fill_in "Outlet", with: @bound.outlet_id
    fill_in "Standard", with: @bound.standard_id
    fill_in "To", with: @bound.to
    click_on "Update Bound"

    assert_text "Bound was successfully updated"
    click_on "Back"
  end

  test "destroying a Bound" do
    visit bounds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bound was successfully destroyed"
  end
end
