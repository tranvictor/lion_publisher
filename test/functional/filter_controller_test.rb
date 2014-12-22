require 'test_helper'

class FilterControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # test for :index and :all action
  test "should return root path when get index (guest)" do
    get :index
    assert_redirected_to root_path
    assert_equal 'Only writer or admin can access this area!!!', flash[:notice]
  end
  test "should return root path when get all articles (guest)" do
    get :all
    assert_redirected_to root_path
    assert_equal 'Only writer or admin can access this area!!!', flash[:notice]
  end

  test "should return root path when get index (normal user)" do
    login_as_normal_user
    get :index
    assert_redirected_to root_path
    assert_equal 'Only writer or admin can access this area!!!', flash[:notice]
  end
  test "should return root path when get all articles (normal user)" do
    login_as_normal_user
    get :all
    assert_redirected_to root_path
    assert_equal 'Only writer or admin can access this area!!!', flash[:notice]
  end

  test "should get index (writer)" do
    login_as_writer
    get :index
    assert_response :success
    assert_equal(assigns(:isAdmin), false)
  end

  test "should get all (writer)" do
    login_as_writer
    get :all
    assert_response :success
    assert_not_nil assigns(:published)
    assert_not_nil assigns(:not_published)
  end

  test "should get all correct published articles (writer)" do
    login_as_writer
    get :all
    #should return list published articles
    #current fixture is :id => [1, 2, 6..35]
    article_ids = (assigns(:published).map {|x| x.id }).sort
    correct_ids = (6..35).to_a.push(1, 2).sort
    assert_equal(correct_ids, article_ids)
  end

  test "should get all correct not published articles (writer)" do
    login_as_writer
    get :all
    #should return list not published articles
    #current fixture is :id => [3]
    article_ids = (assigns(:not_published).map {|x| x.id }).sort
    correct_ids = [3]
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (admin)" do
    login_as_admin
    get :index
    assert_response :success
    assert_equal(assigns(:isAdmin), true)
  end

  test "should get all (admin)" do
    login_as_admin
    get :all
    assert_response :success
    assert_not_nil assigns(:published)
    assert_not_nil assigns(:not_published)
  end

  test "should get all correct published articles (admin)" do
    login_as_admin
    get :all
    #should return list published articles
    #current fixture is :id => [1, 2, 4, 6..37, 39]
    article_ids = (assigns(:published).map {|x| x.id }).sort
    correct_ids = (6..37).to_a.push(1, 2, 4, 39).sort
    assert_equal(correct_ids, article_ids)
  end

  test "should get all correct not published articles (admin)" do
    login_as_admin
    get :all
    #should return list not published articles
    #current fixture is :id => [3, 5, 38, 40]
    article_ids = (assigns(:not_published).map {|x| x.id }).sort
    correct_ids = [3, 5, 38, 40]
    assert_equal(correct_ids, article_ids)
  end

  test "index should render correct template and layout (admin)" do
    login_as_admin
    get :index
    assert_template :index
  end
  test "all should render correct template and layout (admin)" do
    login_as_admin
    get :all
    assert_template :all
    #when articles.size > 0
    assert_template layout: "layouts/application", partial: '_article_list', count: 2
  end

  test "index should render correct template and layout (writer)" do
    login_as_writer
    get :index
    assert_template :index
  end
  test "all should render correct template and layout (writer)" do
    login_as_writer
    get :all
    assert_template :all
    #when articles.size > 0
    assert_template layout: "layouts/application", partial: '_article_list', count: 2
  end


  #test for :broken and :brokenscanner action
  test "should return root path when get broken articles list(guest)" do
    get :broken
    assert_redirected_to root_path
    assert_equal 'Please login as admin to access this area!', flash[:notice]
  end
  test "should return root path when get start broken scanner (guest)" do
    get :brokenscanner
    assert_redirected_to root_path
    assert_equal 'Please login as admin to access this area!', flash[:notice]
  end

  test "should return root path when get broken articles list (normal user/ writer)" do
    login_as_normal_user
    get :broken
    assert_redirected_to root_path
    assert_equal 'Please login as admin to access this area!', flash[:notice]
  end
  test "should return root path when get start broken scanner (normal user/writer)" do
    login_as_normal_user
    get :brokenscanner
    assert_redirected_to root_path
    assert_equal 'Please login as admin to access this area!', flash[:notice]
  end

  test "should get broken articles list (admin)" do
    login_as_admin
    get :broken
    assert_response :success
    assert_not_nil assigns(:filter_results)
  end

  test "should get start broken scanner (admin)" do
    login_as_admin
    get :brokenscanner
    assert_response :success
  end

  test ":broken should render correct template and layout (admin)" do
    login_as_admin
    get :broken
    assert_template :broken
    assert_template layout: "layouts/application", partial: '_article_list', count: 1
  end
  test ":brokenscanner should render correct template and layout (admin)" do
    login_as_admin
    get :brokenscanner
    assert_template :brokenscanner
  end

  def login_as_admin
    admin = users(:admin)
    admin.confirm!
    @user = User.find(5)
    sign_in @user
  end

  def login_as_writer
    user = users(:writer)
    user.confirm!
    @user = User.find(58)
    sign_in @user
  end

  def login_as_normal_user
    user = users(:normal)
    user.confirm!
    @user = User.find(47)
    sign_in @user
  end
end
