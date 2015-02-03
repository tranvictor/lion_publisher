require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, :type => :model do
  subject(:ability) {Ability.new(user)}

  describe 'Ability' do
    context 'when is an admin' do
      let(:user) {FactoryGirl.create(:user, is_admin: true)}

      it 'should be able to manage all articles' do
        expect(ability).to be_able_to :manage, Article.new
      end

      it 'should be able to manage all categories' do
        expect(ability).to be_able_to :manage, Category.new
      end

      it 'should be able to manage all subscribers' do
        expect(ability).to be_able_to :manage, Subscriber.new
      end

      it 'should be able to manage all users' do
        expect(ability).to be_able_to :manage, User.new
      end

      it 'should be able to manage all messages' do
        expect(ability).to be_able_to :manage, Message.new
      end
    end

    context 'when is a writer' do
      let(:user) {FactoryGirl.create(:user, is_writer: true)}

      it 'should be able to create new articles' do
        expect(ability).to be_able_to :new, Article
        expect(ability).to be_able_to :create, Article
      end

      it 'should not be able to destroy articles' do
        expect(ability).not_to be_able_to :destroy, Article.new
      end

      it 'should be able to edit his/her articles' do
        article = FactoryGirl.build(:article, user_id: user.id)
        expect(ability).to be_able_to :edit, article
      end

      it 'should not be able to edit articles that they do not own' do
        another_article = FactoryGirl.build(:article, user_id: user.id+1)
        expect(ability).not_to be_able_to :edit, another_article
      end
    end

    context 'when is a normal user or is not logged in' do
      let(:user) {FactoryGirl.create(:user)}

      it 'should be able to view articles index' do
        expect(ability).to be_able_to :index, Article
      end

      it 'should be able to view a random published article' do
        expect(ability).to be_able_to :random, Article
      end

      it 'should be able to view published articles' do
        published_article = FactoryGirl.build(:article, published: true)
        expect(ability).to be_able_to :show, published_article
      end

      it 'should not be able to view unpublished articles' do
        unpublished_article = FactoryGirl.build(:article, published: false)
        expect(ability).not_to be_able_to :show, unpublished_article
      end

      it 'should not be able to make changes to articles' do
        expect(ability).not_to be_able_to :new, Article
        expect(ability).not_to be_able_to :create, Article
        expect(ability).not_to be_able_to :update, Article.new
        expect(ability).not_to be_able_to :destroy, Article.new
      end

      it 'should be able to send a message' do
        expect(ability).to be_able_to :new, Message
        expect(ability).to be_able_to :create, Message
      end

      it 'should not be able to view message index' do
        expect(ability).not_to be_able_to :index, Message
      end

      it 'should not be able to view a message' do
        expect(ability).not_to be_able_to :show, Message.new
      end

      it 'should not be able to reply to a message' do
        expect(ability).not_to be_able_to :reply, Message.new
      end

      it 'should not be able to delete a message' do
        expect(ability).not_to be_able_to :destroy, Message.new
      end
    end
  end

end
