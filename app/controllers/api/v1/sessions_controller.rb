class Api::V1::SessionsController < Api::BaseController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = User.find_by(email: login_params[:email])

      raise AuthenticationError unless user&.valid_password?(login_params[:password])
      token = encode_token({ user_id: user.id })

      render json: {
        message: 'Login successful',
        jwt: token,
        user: UserSerializer.new(user).serializable_hash[:data][:attributes],
      }, status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
