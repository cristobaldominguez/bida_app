require "application_system_test_case"

class GraphsTest < ApplicationSystemTestCase
  setup do
    @graph = graphs(:one)
  end

  test "visiting the index" do
    visit graphs_url
    assert_selector "h1", text: "Graphs"
  end

  test "creating a Graph" do
    visit graphs_url
    click_on "New Graph"

    fill_in "Active", with: @graph.active
    fill_in "Comment", with: @graph.comment
    fill_in "Graph Standard", with: @graph.graph_standard_id
    fill_in "Report", with: @graph.report_id
    click_on "Create Graph"

    assert_text "Graph was successfully created"
    click_on "Back"
  end

  test "updating a Graph" do
    visit graphs_url
    click_on "Edit", match: :first

    fill_in "Active", with: @graph.active
    fill_in "Comment", with: @graph.comment
    fill_in "Graph Standard", with: @graph.graph_standard_id
    fill_in "Report", with: @graph.report_id
    click_on "Update Graph"

    assert_text "Graph was successfully updated"
    click_on "Back"
  end

  test "destroying a Graph" do
    visit graphs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Graph was successfully destroyed"
  end
end
