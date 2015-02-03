require 'rails_helper'

RSpec.describe Article, :type => :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:article)).to be_valid
  end

  it "is invalid without a title" do
    expect(Article.new).not_to be_valid
  end

  it "does not allow duplicate titles" do
    FactoryGirl.create(:article)
    expect(FactoryGirl.build(:article)).not_to be_valid
  end
end
