class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from CanCan::AccessDenied, with: :access_denied


  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:email, :name, :password, :password_confirmation, group_attributes: [:name])
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:email, :name, :password, :password_confirmation, :current_password, group_attributes: [:id, :name])
      end
    end

    def after_sign_in_path_for(resource)
      group_lessons_path(current_user.group)
    end

    def access_denied exception
      if user_signed_in?
        redirect_to request.referer || main_app.groups_url, :alert => 'Access denied'
      else
        redirect_to new_user_session_path, :alert => exception.message
      end
    end

end
