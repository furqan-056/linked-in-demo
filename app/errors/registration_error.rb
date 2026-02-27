class RegistrationError < StandardError
  attr_reader :errors

  def initialize(user)
    @errors = user.errors.full_messages
    super(@errors.join(', ').presence)
  end
end
