class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:cust_acct, :shipment_match_reference, :so_match_reference, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:cust_acct, :shipment_match_reference, :so_match_reference, :email, :password, :password_confirmation, :current_password) }
  end

  def authenticate_admin!
    authenticate_user!
    redirect_to users_path  unless current_user.admin?
  end

end
