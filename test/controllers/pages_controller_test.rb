require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pages_index_url
    assert_response :success
  end

  test "should get no_permission" do
    get pages_no_permission_url
    assert_response :success
  end

end
