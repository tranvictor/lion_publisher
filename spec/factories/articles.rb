FactoryGirl.define do
  factory :article do
    title 'test article'
    association :category, factory: :category, strategy: :build
  end
end
