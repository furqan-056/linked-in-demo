class CompanySerializer
  include JSONAPI::Serializer

  attributes :id, :name, :industry, :website, :created_at, :updated_at

  attribute :owner_email do |company|
    company.user&.email
  end
end
