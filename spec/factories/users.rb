FactoryGirl.define do
  factory :user do
    user_name 'test_user'
    email 'trendsread@example.com'
    password 'password'
    password_confirmation 'password'
    confirmed_at Time.now
  end
end
