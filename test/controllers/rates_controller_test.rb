require 'test_helper'

class RatesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rates_path
    assert_response :success
  end
end
