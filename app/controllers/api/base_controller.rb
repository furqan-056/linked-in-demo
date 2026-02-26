class Api::BaseController < ActionController::API
  include Pundit
  before_action :authorize_request

  attr_reader :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from AuthenticationError do |e|
    render json: { error: e.message }, status: :unauthorized
  end
  rescue_from RegistrationError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
  rescue_from JwtTokenMissingError do |e|
    render json: { error: e.message }, status: :unauthorized
  end
  rescue_from JwtTokenInvalidError do |e|
    render json: { error: e.message }, status: :unauthorized
  end

  private

  def user_not_authorized
    render json: { error: "Forbidden" }, status: :forbidden
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    raise JwtTokenMissingError unless token

    decoded = decode_token(token)
    raise JwtTokenInvalidError unless decoded

    @current_user = User.find_by(id: decoded.dig(0, 'user_id'))
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
