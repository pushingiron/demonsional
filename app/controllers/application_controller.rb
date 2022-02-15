class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:cust_acct,
               :shipment_match_reference,
               :so_match_reference,
               :edge_pack_url,
               :edge_pack_id,
               :edge_pack_pwd,
               :ws_user_id,
               :ws_user_pwd,
               :report_user,
               :email, :password,
               :password_confirmation,
               :remember_me,
               :server)
    end
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:cust_acct,
               :shipment_match_reference,
               :so_match_reference,
               :edge_pack_url,
               :edge_pack_id,
               :edge_pack_pwd,
               :ws_user_id,
               :ws_user_pwd,
               :report_user,
               :email,
               :password,
               :password_confirmation,
               :current_password,
               :server)
    end
  end

  def authenticate_admin!
    authenticate_user!
    redirect_to users_path  unless current_user.admin?
  end

end
