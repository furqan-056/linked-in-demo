class Api::V1::RegistrationsController < Api::BaseController
  skip_before_action :authorize_request, only: %i[create]

  def create
    user = User.new(user_params)
    raise RegistrationError.new(user) unless user.save
    token = encode_token({ user_id: user.id })
    render json: UserSerializer.with_auth_meta(user, token), status: :created
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :role)
  end

  def serialized_user(user)
    UserSerializer.new(user).serializable_hash.dig(:data, :attributes)
  end
end
