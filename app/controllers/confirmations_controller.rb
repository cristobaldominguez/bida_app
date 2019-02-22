class ConfirmationsController < Devise::ConfirmationsController

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      # respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
      redirect_to users_path, notice: 'Confirmation was resend.'
    else
      respond_with(resource)
    end
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource) # In case you want to sign in the user
    authenticated_root_path
  end
end
