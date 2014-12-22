require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @article = articles(:one)
  end


  #test for :index

  test "should get index (page=1)" do
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  #test "should get index (page=1) with correct articles list" do
  #  get :index
  #  #should return page 1: 30 articles (created_at DESC, category_id != 3, published == true)
  #  #current fixture is :id => [37..8]
  #  article_ids = assigns(:articles).map {|x| x.id }
  #  correct_ids = (8..37).to_a.reverse
  #  assert_equal(correct_ids, article_ids)
  #end

  test "should get index (page=1) with :mostpopular==false" do
    get :index
    assert !assigns(:mostpopular), 'mostpopular should be false'
  end

  test "should get index (page=2)" do
    get :index, {'page' => '2'}
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  #test "should get index (page=2) with correct articles list" do
  #  get :index, {'page' => '2'}
  #  #should return page 2: 4 articles (created_at DESC, category_id != 3, published == true)
  #  #current fixture is :id => [7, 6, 4, 2, 1]
  #  article_ids = assigns(:articles).map {|x| x.id }
  #  correct_ids = [7, 6, 4, 2, 1]
  #  assert_equal(correct_ids, article_ids)
  #end

  test "should get index (page=2) with :mostpopular==false" do
    get :index, {'page' => '2'}
    assert !assigns(:mostpopular), 'mostpopular should be false'
  end

  test "should get index (category) (page=1)" do
    get :index, {'category' => '1'}
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get index (category) (page=1) with correct articles list" do
    get :index, {'category' => '1'}
    #should return page 1: 30 articles (created_at DESC, category_id == 1, published == true)
    #current fixture is :id => [35..6]
    article_ids = assigns(:articles).map {|x| x.id }
    correct_ids = (6..35).to_a.reverse
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (category) (page=1) with :mostpopular==false" do
    get :index, {'category' => '1'}
    assert !assigns(:mostpopular), 'mostpopular should be false'
  end

  test "should get index (category) (page=2)" do
    get :index, {category: '1', page: '2'}
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get index (category) (page=2) with correct articles list" do
    get :index, {category: '1', page: '2'}
    #should return page 1: 3 articles (created_at DESC, category_id == 1, published == true)
    #current fixture is :id => [4, 2, 1]
    article_ids = assigns(:articles).map {|x| x.id }
    correct_ids = [4, 2, 1]
    assert_equal(correct_ids, article_ids)
  end

  test "should get index (category) (page=2) with :mostpopular==false" do
    get :index, {category: '1', page: '2'}
    assert !assigns(:mostpopular), 'mostpopular should be false'
  end

  test "should get index (mostpopular=true) (page=1)" do
    get :index, {'mostpopular' => 'true'}
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  #test "should get index (mostpopular=true) (page=1) with correct articles list" do
  #  get :index, {'mostpopular' => 'true'}
  #  #should return page 1: 30 articles (impressions_count DESC, category_id != 3, published == true)
  #  #current fixture is :id => [1, 2, 4, 6..32]
  #  article_ids = assigns(:articles).map {|x| x.id }
  #  correct_ids = (6..32).to_a.push(1, 2, 4).sort
  #  assert_equal(correct_ids, article_ids)
  #end

  test "should get index (mostpopular=true) (page=1) with :mostpopular==true" do
    get :index, {'mostpopular' => 'true'}
    assert assigns(:mostpopular), 'mostpopular should be true'
  end

  test "should get index (mostpopular=true) (page=2)" do
    get :index, {mostpopular: 'true', page: '2'}
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  #test "should get index (mostpopular=true) (page=2) with correct articles list" do
  #  get :index, {mostpopular: 'true', page: '2'}
  #  #should return page 1: 4 articles (impressions_count DESC, category_id != 3, published == true)
  #  #current fixture is :id => [33..37]
  #  article_ids = assigns(:articles).map {|x| x.id }
  #  correct_ids = (33..37).to_a.reverse
  #  assert_equal(correct_ids, article_ids)
  #end

  test "should get index (mostpopular=true) (page=2) with :mostpopular==true" do
    get :index, {mostpopular: 'true', page: '2'}
    assert assigns(:mostpopular), 'mostpopular should be true'
  end

  test "index should render correct template and layout" do
    get :index
    assert_template :index
    assert_template layout: 'layouts/application', partial: '_thumbnail2.0'
  end


  #test for :random

  test "should get correct article (category_id != 3) when get random" do
    get :random
    assert Article.find(assigns(:article).id).category_id != 3,
           "return article with category_id == 3"
  end

  test "should get correct article (published == true) when get random" do
    get :random
    assert Article.find(assigns(:article).id).published,
           "return not-published article when get random"
  end

  test "should return article path after get random" do
    get :random
    assert_redirected_to article_path(assigns(:article))
  end


  #test for :new

  test "should return new user session path when get new (guest)" do
    get :new
    assert_redirected_to new_user_session_path
    assert_equal "Please login first!!!", flash[:notice]
  end

  test "should return root path when get new (normal user)" do
    login_as_normal_user
    get :new
    assert_redirected_to root_path
    assert_equal "Only writer or admin can access this area!!!", flash[:notice]
  end

  test "should get new (writer)" do
    login_as_writer
    get :new
    assert_response :success
  end

  test "should get new (writer) with all categories" do
    login_as_writer
    get :new
    assert_equal(assigns(:categories).size, Category.all.count)
  end

  test "should get new (admin)" do
    login_as_admin
    get :new
    assert_response :success
  end

  test "should get new (admin) with all categories" do
    login_as_admin
    get :new
    assert_equal(assigns(:categories).size, Category.all.count)
  end

  test "new should render correct template and layout (writer)" do
    login_as_writer
    get :new
    assert_template :new
  end

  test "new should render correct template and layout (admin)" do
    login_as_admin
    get :new
    assert_template :new
  end


  #test for :create

  test "should return login admin path when get create (guest)" do
    post :create, article: { title: 'new title test' }
    assert_redirected_to :controller=>'admin', :action=>'login'
  end

  test "should return login admin path when get create (normal user)" do
    login_as_normal_user
    post :create, article: { title: 'new title test' }
    assert_redirected_to :controller=>'admin', :action=>'login'
  end

  test "should create article (writer)" do
    login_as_writer
    assert_difference('Article.count') do
      post :create, article: { title: 'new title test' }
    end
  end

  test "should create correct article (writer)" do
    login_as_writer
    post :create, article: { title: 'new title test' }
    assert assigns(:article).user == @user, 'incorrect author'
    assert !assigns(:article).published, 'published article right after saved'
  end

  test "should create correct article title input (writer)" do
    login_as_writer
    post :create, article: { title: 'new title test' }
    assert assigns(:article).title == 'new title test', 'incorrect title'
  end

  test "should return edit article path after create article (writer)" do
    login_as_writer
    post :create, article: { title: 'new title test' }
    assert_redirected_to edit_article_path(assigns(:article))
  end

  test "should create article (admin)" do
    login_as_admin
    assert_difference('Article.count') do
      post :create, article: { title: 'new title test' }
    end
  end

  test "should create correct article (admin)" do
    login_as_admin
    post :create, article: { title: 'new title test' }
    assert assigns(:article).user == @user, 'incorrect author'
    assert !assigns(:article).published, 'published article right after saved'
  end

  test "should create correct article title input (admin)" do
    login_as_admin
    post :create, article: { title: 'new title test' }
    assert assigns(:article).title == 'new title test', 'incorrect title'
  end

  test "should return edit article path after create article (admin)" do
    login_as_admin
    post :create, article: { title: 'new title test' }
    assert_redirected_to edit_article_path(assigns(:article))
  end


  #test for :show

  test "should return root path when show article which doesn't exist" do
    login_as_admin
    get :show, id: '0'
    assert_redirected_to root_path
  end

  test "should return root path when show not-published article (guest) " do
    get :show, id: articles(:three)
    assert_redirected_to root_path
  end

  test "should return root path when show not-published article (normal user) " do
    get :show, id: articles(:three)
    assert_redirected_to root_path
  end

  test "should return root path when show not-published article\
  (belongs to another writer) " do
    login_as_writer
    get :show, id: Article.find(37)
    assert_redirected_to root_path
  end

  test "should show article" do
    get :show, id: @article
    assert_response :success
    assert_equal(assigns(:article), @article)
  end

  test "should show article (actegory == nil, user = nil)" do
    article = Article.find(36)
    get :show, id: article
    assert_response :success
    assert_equal(assigns(:article), article)
  end

  test "should show article with correct random articles (size)" do
    get :show, id: @article
    assert_equal(assigns(:random_articles).size, 12)
  end

  test "should show article with correct random articles (different id)" do
    get :show, id: @article
    assert_equal(assigns(:random_articles).count { |x| x.id == @article.id}, 0)
  end

  test "should show article with correct random articles (category_id != 3)" do
    get :show, id: @article
    assert_equal(assigns(:random_articles).count {
                                  |x| Article.find(x.id).category_id == 3}, 0)
  end

  test "should show article with correct random articles (published == true)" do
    get :show, id: @article
    assert_equal(assigns(:random_articles).count {
                                  |x| Article.find(x.id).published == false}, 0)
  end

  test "should increase counter when show article" do
    assert_difference('Article.find(1).impressions_count') do
      get :show, id: @article
    end
  end

  test "should show article with correct recommend articles (size)" do
    get :show, id: @article
    assert_equal(assigns(:recommend_articles).size, 12)
  end

  test "should show article with correct recommend articles (different id)" do
    get :show, id: @article
    assert_equal(assigns(:recommend_articles).count { |x| x.id == @article.id}, 0)
  end

  test "should show article with correct recommend articles (same category_id)" do
    get :show, id: @article
    assert_equal(assigns(:recommend_articles).count {
                  |x| Article.find(x.id).category_id != @article.category_id}, 0)
  end

  test "should show article with recommend articles (when category = nil)" do
    get :show, id: Article.find(36)
    assert_equal(assigns(:recommend_articles).size, 12)
    assert_equal(assigns(:recommend_articles).count { |x| x.id == 36}, 0)
    assert_equal(assigns(:recommend_articles).count {
                  |x| Article.find(x.id).published == false}, 0)
  end

  test "should show article with correct recommend articles (published == true)" do
    get :show, id: @article
    assert_equal(assigns(:recommend_articles).count {
                  |x| Article.find(x.id).published == false}, 0)
  end

  test "should return root path when show empty article" do
    get :show, id: Article.find(2)
    assert_redirected_to root_path
  end

  test "should show article with correct index (nil => 0)" do
    get :show, id: @article
    assert_equal(assigns(:index), 0)
  end

  test "should show article with correct index (index <>=> 0)" do
    get :show, id: @article, :page => '-1'
    assert_equal(assigns(:index), 0)
  end

  test "should show article with correct index (index >= pages.lenth)" do
    get :show, id: @article, :page => '10'
    assert_equal(assigns(:index), 1)
  end

  test "should show article with correct page" do
    get :show, id: @article, :page => '1'
    assert_equal(assigns(:page), Page.find(2))
  end

  test "should show article with correct next article (not last page)" do
    get :show, id: @article, :page => '0'
    assert_nil assigns(:next_article)
  end

  test "should show article with correct next article (last page)" do
    get :show, id: @article, :page => '1'
    assert_not_nil assigns(:next_article)
  end

  test "show should render correct template and layout" do
    get :show, id: @article
    assert_template :show
  end

  test "show should render correct template and layout (with partial likebutton)" do
    get :show, id: @article
    assert_template layout: "layouts/application", partial: "_likebutton", count: 1
  end

  test "show should render correct template and layout\
  (with partial tweetbutton)" do
    get :show, id: @article
    assert_template layout: "layouts/application", partial: "_tweetbutton", count: 1
  end

  test "show should render correct template and layout\
  (with partial recommendations_sly)" do
    get :show, id: @article
    # TODO: the :locals option to #assert_template is only supported in a
    #       ActionView::TestCase
    # Should remove locals:, find another way to test locals
    assert_template layout: "layouts/application",
                    partial: "_recommendations_sly", count: 1
    #,              locals: {articles: assigns(:recommend_articles)}
  end

  test "show should render correct template and layout\
  (with partial thumbnail2.0)" do
    get :show, id: @article
    assert_template layout: "layouts/application", partial: "_thumbnail2.0"
  end


  #test for :edit

  test "should return new user session path when get edit (guest)" do
    get :edit, id: @article
    assert_redirected_to new_user_session_path
    assert_equal "Please login first!!!", flash[:notice]
  end

  test "should return root path when get edit (normal user)" do
    login_as_normal_user
    get :edit, id: @article
    assert_redirected_to root_path
    assert_equal "Only writer or admin can edit this article!!!", flash[:notice]
  end

  test "should return root path when get edit article which\
  belongs to another writer" do
    login_as_writer
    get :edit, id: Article.find(37)
    assert_redirected_to root_path
    assert_equal "You can't edit this article!!!", flash[:notice]
  end

  test "should return root path when get edit article which doesn't exist" do
    login_as_admin
    get :edit, id: '0'
    assert_redirected_to root_path
  end

  test "should get edit (writer)" do
    login_as_writer
    get :edit, id: @article
    assert_response :success
  end

  test "should get edit (writer) with all categories" do
    login_as_writer
    get :edit, id: @article
    assert_equal(assigns(:categories).size, Category.all.count)
  end

  test "should get edit (writer) with correct created pages" do
    login_as_writer
    get :edit, id: @article
    assert_equal(assigns(:created_pages), @article.pages.order('page_no'))
  end

  test "should get edit (admin)" do
    login_as_admin
    get :edit, id: @article
    assert_response :success
  end

  test "should get edit (admin) with all categories" do
    login_as_admin
    get :edit, id: @article
    assert_equal(assigns(:categories).size, Category.all.count)
  end

  test "should get edit (admin) with correct created pages" do
    login_as_writer
    get :edit, id: @article
    assert_equal(assigns(:created_pages), @article.pages.order('page_no'))
  end

  test "edit should render correct template and layout (writer)" do
    login_as_writer
    get :edit, id: @article
    assert_template :edit
    assert_template layout: "layouts/application", partial: "_page_form"
  end

  test "edit should render correct template and layout (admin)" do
    login_as_admin
    get :edit, id: @article
    assert_template :edit
    assert_template layout: "layouts/application", partial: "_page_form"
  end


  #test for :update

  test "update should return root path (guest)" do
    xhr :put, :update, id: @article, article: { title: 'change'}
    assert_redirected_to root_path
  end

  test "update should return root path (normal_user)" do
    login_as_normal_user
    xhr :put, :update, id: @article, article: { title: 'change'}
    assert_redirected_to root_path
  end

  test "update should return root path (another writer)" do
    login_as_writer
    xhr :put, :update, id: Article.find(37), article: { title: 'change'}
    assert_redirected_to root_path
  end

  test "should update article" do
    login_as_admin
    xhr :put, :update, id: @article, article: { title: 'change'}
    assert_response :success
  end

  test "should update article with correct title" do
    login_as_admin
    xhr :put, :update, id: @article, article: { title: 'change'}
    @article.reload
    assert_equal @article.title, 'change'
  end

  test "should update article with correct published" do
    login_as_admin
    old_published = @article.published
    xhr :put, :update, id: @article, article: { published: !old_published}
    @article.reload
    assert_equal @article.published, !old_published
  end

  test "should update article with correct category_id" do
    login_as_admin
    xhr :put, :update, id: @article, article: { category_id: 2}
    @article.reload
    assert_equal @article.category_id, 2
  end

  test "should update article with correct pages order" do
    login_as_admin
    page1 = pages(:one)
    page2 = pages(:two)
    xhr :put, :update, id: @article,
        page_1: { body: page2.body}, page_2: { body: page1.body}
    assert_equal Page.find(1).body, 'MyText 2'
  end

  test "should update article with new page" do
    login_as_admin
    url = 'http://upload.wikimedia.org/wikipedia/en/e/e0/Iron_Man_bleeding_edge.jpg'
    assert_difference('Article.find(1).pages.count') do
      xhr :put, :update, id: @article, 'image-urls' => url
    end
  end

  test "should update article with correct new page" do
    login_as_admin
    url = 'http://upload.wikimedia.org/wikipedia/en/e/e0/Iron_Man_bleeding_edge.jpg'
    xhr :put, :update, id: @article, 'image-urls' => url
    new_page = @article.pages.order('page_no').last
    assert_equal new_page.citation, url
    assert_equal new_page.broken, false
  end


  #test for :destroy

  test "shouldn't destroy article (guest)" do
    assert_no_difference('Article.count') do
      delete :destroy, id: @article
    end
    assert_redirected_to root_path
  end

  test "shouldn't destroy article (normal_user)" do
    login_as_normal_user
    assert_no_difference('Article.count') do
      delete :destroy, id: @article
    end
    assert_redirected_to root_path
  end

  test "shouldn't destroy article (writer)" do
    login_as_writer
    assert_no_difference('Article.count') do
      delete :destroy, id: @article
    end
    assert_redirected_to root_path
  end

  test "should destroy article (admin)" do
    login_as_admin
    assert_difference('Article.count', -1) do
      delete :destroy, id: @article
    end
    assert_redirected_to articles_path
  end

  test "should destroy correct article (admin)" do
    login_as_admin
    delete :destroy, id: @article
    assert_equal Article.where(id: 1), []
  end


  private
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
