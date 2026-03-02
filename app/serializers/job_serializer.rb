class JobSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :salary, :location, :expiry_date, :status, :created_at, :updated_at

  attribute :company_name do |job|
    job.company&.name
  end
end
