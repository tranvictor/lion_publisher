require 'rails_helper'

RSpec.describe Message, :type => :model do
  describe 'Message' do
    it 'have a valid factory' do
      expect(FactoryGirl.build(:message)).to be_valid
    end

    it 'is invalid without a sender name' do
      expect(FactoryGirl.build(:message, name: nil)).not_to be_valid
    end

    it 'is invalid without a valid email' do
      expect(FactoryGirl.build(:message, email: nil)).not_to be_valid
      expect(FactoryGirl.build(:message, email: 'invalid email')).not_to be_valid
    end

    it 'is invalid without a title' do
      expect(FactoryGirl.build(:message, title: nil)).not_to be_valid
    end

    it 'is invalid without a body' do
      expect(FactoryGirl.build(:message, body: nil)).not_to be_valid
    end

    it 'is invalid if the body is too long' do
      too_long_body = ''
      4001.times {too_long_body += '_'}
      expect(FactoryGirl.build(:message, body: too_long_body)).not_to be_valid
    end
  end
end
