class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :role

  def self.with_auth_meta(user, token)
    new(user, meta: { message: 'Login successful', jwt: token })
  end
end
