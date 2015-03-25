require 'rails_helper'

RSpec.describe ArticlesController, :type => :controller do
  let(:user) { FactoryGirl.create(:user)}
  let(:admin){ FactoryGirl.create(:user, :admin)}

  let(:writer) { FactoryGirl.create(:user, :writer)}
  let(:published_article) { FactoryGirl.create(:article, user_id: writer.id, published: true)}
  let(:unpublished_article) { FactoryGirl.create(:article, title: 'another article', published: false)}
  let(:articles) { [published_article, unpublished_article]}

  describe 'When a user sign in' do
    before(:each) do
      sign_in user
    end

    context 'GET index' do
      before(:each) do
        get :index
      end

      it 'should complete the request successfully' do
        expect(response).to have_http_status('200')
      end

      it 'should show published articles' do
        expect(assigns(:articles)).to include(published_article)
      end

      it 'should not show unpublished articles' do
        expect(assigns(:articles)).not_to include(unpublished_article)
      end
    end

    context 'GET show' do
      it 'should allow users to view a published article' do
        get :show, id: published_article
        expect(response).to have_http_status('200')
      end

      it 'should not allow users to view an unpublished article' do
        get :show, id: unpublished_article
        expect(response).to have_http_status('302')
      end
    end

    context 'GET random' do
      before(:each) do
        get :random
      end

      # it 'should redirect to a random article' do
      #   expect(response).to redirect_to(assigns(:article))
      #   expect(assigns(:article)).to be_a(Article)
      # end

      # it 'should be a published article' do
      #   expect(assigns(:article)).to be_a(Article)
      # end
    end
   end

  describe "When an author signed in" do
    before(:each) do
      sign_in writer
    end

    context 'GET show' do
      it 'should allow an author to view a published article' do
        get :show, id: published_article
        expect(response).to have_http_status('200')
      end

      it 'should not allow a writer to view an unpublished article written by another writer' do
        get :show, id: unpublished_article
        expect(response).to have_http_status('302')
      end

      it 'should allow a writer to view his/her unpublished articles' do
        tmp = FactoryGirl.create(:article, title: 'another article', published: false, user_id: writer.id )
        get :show, id: tmp
        expect(response).to have_http_status('200')
      end
    end

    context 'GET new' do
      before(:each) do
        get :new
      end

      it 'should assign a new article as @article' do
        article = assigns(:article)
        expect(article).to be_a_new(Article)
      end
    end

    context 'POST create' do
      before(:each) do
        @params = FactoryGirl.attributes_for(:article)
      end

      it 'doesnt save new article without a valid title and generate title error message' do
        @params[:title] = nil
        expect do
          post :create, article: @params
          @not_saved_article = assigns(:article)
        end.to change {user.articles.count}.by(0)

        expect(@not_saved_article.errors[:title]).not_to be_blank
      end

      it 'creates a new article with valid params' do
        expect{
          post :create, :article => @params
        }.to change {writer.articles.count}.by(1)
      end

      it 'redirects to the edit step' do
        post :create, :article => @params
        @saved_article = assigns(:article)
        expect(response).to redirect_to(edit_article_path(@saved_article))
      end
    end

    context 'GET edit' do
      before(:each) do
        @params = FactoryGirl.attributes_for(:article)
      end

      it 'render edit template successfully' do
        get :edit, :id => published_article
        expect(response).to render_template("edit")
      end

      it 'redirects to root if he is not the author of the article' do
        get :edit, :id => unpublished_article
        expect(response).to redirect_to(root_path)
      end
    end

    context 'DELETE destroy' do
      it 'doesnt allow an author to delete his posts' do
        expect{
          delete :destroy, :id => published_article
        }.to change {writer.articles.count}.by(0)
      end
    end
  end
end
