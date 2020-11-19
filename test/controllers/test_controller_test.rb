require 'test_helper'

class TestControllerTest < ActionDispatch::IntegrationTest
  test "should get inbound" do
    get test_inbound_url
    assert_response :success
  end

  test "should get outbound" do
    get test_outbound_url
    assert_response :success
  end

end
