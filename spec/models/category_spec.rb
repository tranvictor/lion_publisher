require 'rails_helper'

RSpec.describe Category, :type => :model do
  it "have a valid factory" do
    expect(FactoryGirl.build(:category)).to be_valid
  end

  it "should not be valid without a name" do
    expect(Category.new).not_to be_valid
  end

  it "should not allow duplicate names" do
    FactoryGirl.create(:category)
    expect(FactoryGirl.build(:category)).not_to be_valid
  end
end
