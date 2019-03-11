require "application_system_test_case"

class GraphStandardsTest < ApplicationSystemTestCase
  setup do
    @graph_standard = graph_standards(:one)
  end

  test "visiting the index" do
    visit graph_standards_url
    assert_selector "h1", text: "Graph Standards"
  end

  test "creating a Graph standard" do
    visit graph_standards_url
    click_on "New Graph Standard"

    fill_in "Active", with: @graph_standard.active
    fill_in "Chart", with: @graph_standard.chart_id
    fill_in "Plant", with: @graph_standard.plant_id
    fill_in "Show", with: @graph_standard.show
    click_on "Create Graph standard"

    assert_text "Graph standard was successfully created"
    click_on "Back"
  end

  test "updating a Graph standard" do
    visit graph_standards_url
    click_on "Edit", match: :first

    fill_in "Active", with: @graph_standard.active
    fill_in "Chart", with: @graph_standard.chart_id
    fill_in "Plant", with: @graph_standard.plant_id
    fill_in "Show", with: @graph_standard.show
    click_on "Update Graph standard"

    assert_text "Graph standard was successfully updated"
    click_on "Back"
  end

  test "destroying a Graph standard" do
    visit graph_standards_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Graph standard was successfully destroyed"
  end
end
