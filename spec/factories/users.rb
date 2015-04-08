FactoryGirl.define do
  factory :user do
    user_name 'test_user'
    email 'trendsread@example.com'
    password 'password'
    password_confirmation 'password'
    confirmed_at Time.now
    is_writer false
    is_admin false
    
    trait :writer do
      user_name 'author_user'
      email 'writer@email.com'
      is_writer true
    end

    trait :admin do
      user_name 'admin_user'
      email "admin@email.com"
      is_admin true
    end
  end

end
