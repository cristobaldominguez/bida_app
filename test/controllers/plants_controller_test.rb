require 'test_helper'

class PlantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plant = plants(:one)
  end

  test "should get index" do
    get plants_url
    assert_response :success
  end

  test "should get new" do
    get new_plant_url
    assert_response :success
  end

  test "should create plant" do
    assert_difference('Plant.count') do
      post plants_url, params: { plant: { active: @plant.active, address01: @plant.address01, address02: @plant.address02, code: @plant.code, company_id: @plant.company_id, flow_design: @plant.flow_design, internal_number_per_cycle: @plant.internal_number_per_cycle, lab_number_per_cycle: @plant.lab_number_per_cycle, name: @plant.name, phone: @plant.phone, startup_date: @plant.startup_date, state: @plant.state, zip: @plant.zip } }
    end

    assert_redirected_to plant_url(Plant.last)
  end

  test "should show plant" do
    get plant_url(@plant)
    assert_response :success
  end

  test "should get edit" do
    get edit_plant_url(@plant)
    assert_response :success
  end

  test "should update plant" do
    patch plant_url(@plant), params: { plant: { active: @plant.active, address01: @plant.address01, address02: @plant.address02, code: @plant.code, company_id: @plant.company_id, flow_design: @plant.flow_design, internal_number_per_cycle: @plant.internal_number_per_cycle, lab_number_per_cycle: @plant.lab_number_per_cycle, name: @plant.name, phone: @plant.phone, startup_date: @plant.startup_date, state: @plant.state, zip: @plant.zip } }
    assert_redirected_to plant_url(@plant)
  end

  test "should destroy plant" do
    assert_difference('Plant.count', -1) do
      delete plant_url(@plant)
    end

    assert_redirected_to plants_url
  end
end
