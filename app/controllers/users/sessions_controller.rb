class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash.now[:alert] = "Invalid email or password"
      self.resource = resource_class.new(sign_in_params)
      render :new
    end
  end
end
