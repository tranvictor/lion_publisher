require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, :type => :model do
  subject(:ability) {Ability.new(user)}

  describe 'Ability' do
    context 'when is ad admin' do
      let(:user) {FactoryGirl.create(:user, is_admin: true)}

      it 'should be able to manage any articles' do
        expect(ability).to be_able_to :manage, Article.new
      end

      it 'should be able to manage any categories' do
        expect(ability).to be_able_to :manage, Category.new
      end

      it 'should be able to manage any subscribers' do
        expect(ability).to be_able_to :manage, Subscriber.new
      end

      it 'should be able to manage any users' do
        expect(ability).to be_able_to :manage, User.new
      end
    end
  end

end
