require "application_system_test_case"

class PlantsTest < ApplicationSystemTestCase
  setup do
    @plant = plants(:one)
  end

  test "visiting the index" do
    visit plants_url
    assert_selector "h1", text: "Plants"
  end

  test "creating a Plant" do
    visit plants_url
    click_on "New Plant"

    fill_in "Active", with: @plant.active
    fill_in "Address01", with: @plant.address01
    fill_in "Address02", with: @plant.address02
    fill_in "Code", with: @plant.code
    fill_in "Company", with: @plant.company_id
    fill_in "Flow Design", with: @plant.flow_design
    fill_in "Internal Number Per Cycle", with: @plant.internal_number_per_cycle
    fill_in "External Number Per Cycle", with: @plant.external_number_per_cycle
    fill_in "Name", with: @plant.name
    fill_in "Phone", with: @plant.phone
    fill_in "Startup Date", with: @plant.startup_date
    fill_in "State", with: @plant.state
    fill_in "Zip", with: @plant.zip
    click_on "Create Plant"

    assert_text "Plant was successfully created"
    click_on "Back"
  end

  test "updating a Plant" do
    visit plants_url
    click_on "Edit", match: :first

    fill_in "Active", with: @plant.active
    fill_in "Address01", with: @plant.address01
    fill_in "Address02", with: @plant.address02
    fill_in "Code", with: @plant.code
    fill_in "Company", with: @plant.company_id
    fill_in "Flow Design", with: @plant.flow_design
    fill_in "Internal Number Per Cycle", with: @plant.internal_number_per_cycle
    fill_in "External Number Per Cycle", with: @plant.external_number_per_cycle
    fill_in "Name", with: @plant.name
    fill_in "Phone", with: @plant.phone
    fill_in "Startup Date", with: @plant.startup_date
    fill_in "State", with: @plant.state
    fill_in "Zip", with: @plant.zip
    click_on "Update Plant"

    assert_text "Plant was successfully updated"
    click_on "Back"
  end

  test "destroying a Plant" do
    visit plants_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Plant was successfully destroyed"
  end
end
