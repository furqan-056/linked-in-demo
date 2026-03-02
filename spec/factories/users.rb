FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password123" }
    role { "candidate" }
  end
end
