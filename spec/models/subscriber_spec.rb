require 'rails_helper'

RSpec.describe Subscriber, :type => :model do
    it "has a valid factory" do
    expect(FactoryGirl.build(:subscriber)).to be_valid
  end

  it "is invalid without a title" do
    expect(Subscriber.new).not_to be_valid
  end

  it "does not allow duplicate titles" do
    FactoryGirl.create(:subscriber)
    expect(FactoryGirl.build(:subscriber)).not_to be_valid
  end
end
