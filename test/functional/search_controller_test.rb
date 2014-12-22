require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should return root path when get index without keyword" do
    login_as_admin
    get :index
    assert_redirected_to root_path
  end

  test "should get index (guest) with keyword" do
    get :index, {:keyword => 'MyString'}
    assert_response :success
  end

  test "should get index (guest) with correct search result (page 1)" do
    get :index,  {:keyword => 'MyString'}
    #should return list articles
    # (which has published == true from first 30 founded articles)
    #current fixture is :id => [2, 4, 6..31]
    article_ids = (assigns(:articles).map {|x| x.id }).sort
    correct_ids = (6..31).to_a.push(2, 4).sort
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (guest) with correct search result" do
    get :index,  {:keyword => 'MyText'}
    #should return list pages
    #current fixture is :id => [1, 2, 3]
    page_ids = (assigns(:pages).map {|x| x.id }).sort
    correct_ids = [1, 2, 3]
    assert_equal(correct_ids, page_ids)
  end

  test "should get index (guest) with correct search result (page 2)" do
    get :index,  {:keyword => 'MyString', :page => 2}
    #should return list articles
    # (which has published == true from next founded articles)
    #current fixture is :id => [32..37, 39]
    article_ids = (assigns(:articles).map {|x| x.id }).sort
    correct_ids = (32..37).to_a.push(39).sort
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (writer) with correct search result (page 1)" do
    login_as_writer
    get :index,  {'keyword' => 'MyString'}
    #should return list articles
    #current fixture is :id => [2..4, 6..31]
    article_ids = (assigns(:articles).map {|x| x.id }).sort
    correct_ids = (6..31).to_a.push(2, 3, 4).sort
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (writer) with correct search result" do
    login_as_writer
    get :index,  {'keyword' => 'MyText'}
    #should return list pages
    #current fixture is :id => [1, 2, 3]
    page_ids = (assigns(:pages).map {|x| x.id }).sort
    correct_ids = [1, 2, 3]
    assert_equal(correct_ids, page_ids)
  end

  test "should get index (writer) with correct search result (page 2)" do
    login_as_writer
    get :index,  {'keyword' => 'MyString', :page => 2}
    #should return list articles
    #current fixture is :id => [32..37, 39]
    article_ids = (assigns(:articles).map {|x| x.id }).sort
    correct_ids = (32..37).to_a.push(39).sort
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (admin) with correct search result (page 1)" do
    login_as_admin
    get :index,  {'keyword' => 'MyString'}
    #should return list articles
    #current fixture is :id => [2..31]
    article_ids = (assigns(:articles).map {|x| x.id }).sort
    correct_ids = (2..31).to_a
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (admin) with correct search result" do
    login_as_admin
    get :index,  {'keyword' => 'MyText'}
    #should return list pages
    #current fixture is :id => [1, 2, 3]
    page_ids = (assigns(:pages).map {|x| x.id }).sort
    correct_ids = [1, 2, 3]
    assert_equal(correct_ids, page_ids)
  end

  test "should get index (admin) with correct search result (page 2)" do
    login_as_admin
    get :index,  {'keyword' => 'MyString', :page => 2}
    #should return list articles
    #current fixture is :id => [32..40]
    article_ids = (assigns(:articles).map {|x| x.id }).sort
    correct_ids = (32..40).to_a
    assert_equal(correct_ids, article_ids)
  end

  test "index should render correct template and layout (article)" do
    get :index, {'keyword' => 'MyString'}
    assert_template :index
    assert_template :layout => false, :partial => '_result_search_article'
  end

  test "index should render correct template and layout (page)" do
    get :index, {'keyword' => 'MyText'}
    assert_template :index
    assert_template :layout => false, :partial => '_result_search_page'
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
