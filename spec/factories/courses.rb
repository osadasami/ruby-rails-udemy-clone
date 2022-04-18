FactoryBot.define do
  factory :course do
    title { 'my super course' }
    description { 'description' }
    language { 'English' }
    level { 'Beginner' }
    price { 100 }
    description_short { 'description_short' }

    user

    transient do
      buyer { nil }
      with_review { false }
    end

    trait :purchased do
      after(:create) do |course, evaluator|
        create(:enrollment, (:with_review if evaluator.with_review), course: course, user: evaluator.buyer)
      end
    end
  end
end
