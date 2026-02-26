class CompanyError < StandardError
  def initialize(msg = "Company operation failed")
    super
  end
end
