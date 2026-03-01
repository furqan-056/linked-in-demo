class JobApplicationSerializer
  include JSONAPI::Serializer

  attributes :id, :status, :created_at, :updated_at

  attribute :job_title do |object|
    object.job.title
  end

  attribute :company_name do |object|
    object.job.company.name
  end

  attribute :candidate_email do |object|
    object.user.email
  end
end
