require 'test_helper'

class IncomingControllerTest < ActionController::TestCase
  test "should get receive_messages" do
    get :receive_messages
    assert_response :success
  end

end
