class AuthenticationError < StandardError
  def initialize(msg = "Invalid email or password")
    super
  end
end
