FactoryBot.define do
  factory :job_application do
    association :user, factory: :user
    association :job, factory: :job
    status { :applied }
  end
end
