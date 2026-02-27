class CompanyError < StandardError
  attr_reader :errors

  def initialize(company)
    @errors = company.errors.full_messages
    super(@errors.present? ? @errors.join(", ") : 'Company operation failed')
  end
end
