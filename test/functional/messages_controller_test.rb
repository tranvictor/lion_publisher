require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @message = messages(:one)
  end

  #test for :index

  test "should return root path when get index (guest)" do
    get :index
    assert_redirected_to root_path
  end

  test "should return root path when get index (normal user)" do
    login_as_normal_user
    get :index
    assert_redirected_to root_path
  end

  test "should get index (admin)" do
    login_as_admin
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should get index with correct messages (admin)" do
    login_as_admin
    get :index
    assert_equal(assigns(:messages), Message.all)
  end

  test "index should render correct template and layout" do
    login_as_admin
    get :index
    assert_template :index
  end


  #test for :new

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:message)
  end

  test "new should render correct layout" do
    get :new
    assert_template :new
    #assert_template partial: "_form"
    assert_template layout: "layouts/application", partial: "_form", count: 1
  end


  #test for :create

  test "should create message" do
    assert_difference('Message.count') do
      post :create, message: { body: @message.body, email: @message.email, ip: @message.ip,
                               name: @message.name, state: @message.state,
                               title: @message.title, user_id: @message.user_id }
    end
  end

  test "should create correct message" do
    post :create, message: { body: @message.body, email: @message.email, ip: @message.ip,
                             name: @message.name, state: @message.state,
                             title: @message.title, user_id: @message.user_id }
    assert_equal(assigns(:message).state, "Unread")
  end

  test "should return root path after create message" do
    post :create, message: { body: @message.body, email: @message.email, ip: @message.ip,
                             name: @message.name, state: @message.state,
                             title: @message.title, user_id: @message.user_id }
    assert_redirected_to root_path
    assert_equal 'Message was successfully sent.', flash[:notice]
  end


  #test for :show

  test "should return root path when get show (guest)" do
    get :show, id: @message
    assert_redirected_to root_path
  end

  test "should return root path when get show (normal user)" do
    login_as_normal_user
    get :show, id: @message
    assert_redirected_to root_path
  end

  test "should show message (admin)" do
    login_as_admin
    get :show, id: @message
    assert_response :success
  end

  test "should show correct message (admin)" do
    login_as_admin
    get :show, id: @message
    assert_equal(assigns(:message), @message)
  end

  test "should change message's state after show" do
    login_as_admin
    get :show, id: @message
    assert_equal(assigns(:message).state, "Read")
  end

  test "show should render correct template and layout" do
    login_as_admin
    get :show, id: @message
    assert_template :show
  end


  #test for :edit and :update

  test "should return root path when edit" do
    get :edit, id: @message
    assert_redirected_to root_path
  end

  test "should return root path when update" do
    put :update, id: @message,
        message: { name: 'name', email: 'abc@gmail.com', title: 'title', body: 'body'}
    assert_redirected_to root_path
  end


  #test for :destroy

  test "shouldn't destroy message (guest)" do
    assert_no_difference('Message.count') do
      delete :destroy, id: @message
    end
  end

  test "shouldn't destroy message (normal user)" do
    login_as_normal_user
    assert_no_difference('Message.count') do
      delete :destroy, id: @message
    end
  end

  test "should destroy message (admin)" do
    login_as_admin
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
    end
    assert_redirected_to messages_path
  end

  test "should destroy correct message (admin)" do
    login_as_admin
    delete :destroy, id: @message
    assert_equal Message.where(id: 1), []
  end


  private
  def login_as_admin
    #@request.env["devise.mapping"] = Devise.mappings[:admin]
    #admin = FactoryGirl.create(:admin)
    #admin.confirm!
    #sign_in :admin, admin
    admin = users(:admin)
    admin.confirm!
    sign_in User.find(5)
  end

  def login_as_normal_user
    user = users(:normal)
    user.confirm!
    sign_in User.find(47)
  end
end
