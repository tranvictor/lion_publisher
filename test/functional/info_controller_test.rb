require 'test_helper'

class InfoControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get term" do
    get :term
    assert_response :success
    assert_template :term
  end

  test "should get privacy" do
    get :privacy
    assert_response :success
    assert_template :privacy
  end

  test "should get dmca" do
    get :dmca
    assert_response :success
    assert_template :dmca
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_template :contact
  end

end
