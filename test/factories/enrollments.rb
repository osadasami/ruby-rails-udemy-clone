FactoryBot.define do
  factory :enrollment do
    user
    course

    trait(:with_review) do
      review { 'good course' }
      rating { 5 }
    end
  end
end
