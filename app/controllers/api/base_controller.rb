class Api::BaseController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    decoded = decode_token(token)

    @current_user = User.find_by(id: decoded[0]['user_id']) if decoded

    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.jwt_secret_key, 'HS256')
  end

  def decode_token(token)
    return nil unless token

    JWT.decode(token, Rails.application.credentials.jwt_secret_key, true, algorithm: 'HS256')
  rescue JWT::DecodeError
    nil
  end
end
