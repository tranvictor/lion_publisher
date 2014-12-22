require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  test "should get login" do
    get :login
    assert_response :success
  end
end
