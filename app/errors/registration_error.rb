class RegistrationError < StandardError
  def initialize(msg = "Signup failed")
    super
  end
end
