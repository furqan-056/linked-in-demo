module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
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
  end
end
