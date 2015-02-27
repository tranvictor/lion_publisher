require 'rails_helper'

RSpec.describe ArticlesController, :type => :controller do
  let(:user) { FactoryGirl.create(:user)}
  let(:admin){ FactoryGirl.create(:user, :admin)}

  let(:writer) { FactoryGirl.create(:user, :writer)}
  let(:published_article) { FactoryGirl.create(:article, user_id: writer, published: true)}
  let(:unpublished_article) { FactoryGirl.create(:article, title: 'another article', published: false )}
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
        tmp = unpublished_article.clone
        tmp.update_attributes(:user_id => writer.id)
        get :show, id: unpublished_article
        expect(response).to have_http_status('200')
      end      
    end
  end
end
