require 'test_helper'

class LocalesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get locales_index_url
    assert_response :success
  end

end
