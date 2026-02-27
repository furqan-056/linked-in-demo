class JwtTokenInvalidError < StandardError
  def initialize(msg = 'Invalid authorization token')
    super
  end
end
