class Api::V1::SessionsController < Api::BaseController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      token = encode_token({ user_id: user.id })

      render json: {
        message: 'Login successful', jwt: token,
        user: {
          id: user.id,
          email: user.email,
          role: user.role
        }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
