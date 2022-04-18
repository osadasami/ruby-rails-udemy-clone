FactoryBot.define do
  factory :user do
    email
    password { 'test@test.com' }
    confirmed_at { DateTime.now }

    trait :admin do
      after(:create) do |user|
        user.add_role(:admin)
      end
    end

    trait :teacher do
      after(:create) do |user|
        user.add_role(:teacher)
      end
    end

    trait :student do
      after(:create) do |user|
        user.add_role(:student)
      end
    end

    trait :with_course do
      after(:create) do |user|
        create(:course, user: user)
      end
    end
  end
end
