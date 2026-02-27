class Api::BaseController < ActionController::API
  include ApiErrorHandler

  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    header = request.headers['Authorization']
    token  = header&.split(' ')&.last
    decoded = decode_token(token)
    user_id = decoded&.dig(0, 'user_id')

    @current_user = User.find_by(id: user_id)
    raise AuthenticationError unless @current_user
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.jwt_secret_key, 'HS256')
  end

  def decode_token(token)
    raise JwtTokenMissingError unless token

    JWT.decode(token, Rails.application.credentials.jwt_secret_key, true, algorithm: 'HS256')
  rescue JWT::DecodeError
    raise JwtTokenInvalidError
  end
end
