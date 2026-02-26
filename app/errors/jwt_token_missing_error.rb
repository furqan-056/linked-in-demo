class JwtTokenMissingError < StandardError
  def initialize(msg = "Authorization token missing")
    super
  end
end
