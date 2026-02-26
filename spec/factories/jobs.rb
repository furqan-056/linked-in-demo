FactoryBot.define do
  factory :job do
    title { "Software Engineer" }
    description { "Job description here" }
    salary { 100000 }
    location { "New York" }
    expiry_date { 1.month.from_now }
    status { "open" }
    association :company
  end
end
