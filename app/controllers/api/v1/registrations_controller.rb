class Api::V1::RegistrationsController < Api::BaseController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = User.new(user_params)

    raise RegistrationError, user.errors.full_messages.join(', ') unless user.save

    token = encode_token({ user_id: user.id })

    render json: {
      message: 'Signup successful',
      jwt: token,
      user: serialized_user(user)
    }, status: :created
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :role)
  end

  def serialized_user(user)
    UserSerializer.new(user).serializable_hash[:data][:attributes]
  end
end
