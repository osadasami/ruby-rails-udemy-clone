RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end
end
