##
# Base Level controller
class ApplicationController < Tempest::ApplicationController
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  # Redirect users to their index page after sign in
  # Redirect users after sign in
  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      resource.admin? ? admin_root_path : user_dashboard_path
    else
      super # This calls the default implementation, which might be root_path or something else
    end
  end


  # def after_sign_out_path_for(resource_or_scope)
  #   # Redirect to a specific path after sign-out
  #   new_user_session_path
  # end

  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :gender, :address_line_1, :address_line_2, :postcode, :state, :suburb])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name, :last_name, :gender, :address_line_1, :address_line_2, :postcode, :state, :suburb])
  end


end



