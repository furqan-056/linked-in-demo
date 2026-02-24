class Api::V1::RegistrationsController < Api::BaseController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = User.new(user_params)

    if user.save
      token = encode_token({ user_id: user.id })

      render json: {
        message: 'Signup successful', jwt: token,
        user: {
          id: user.id,
          email: user.email,
          role: user.role
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :role)
  end
end
