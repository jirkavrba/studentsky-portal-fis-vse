# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Authentication
  def authenticate!
    redirect_to sign_in_url unless authenticated?
  end

  def require_admin_privileges!
    redirect_to root_url unless authenticated? && current_user.is_admin
  end

  def require_valid_api_token!
    return render json: { message: :missing_api_token }, status: :unauthorized if request.headers['x-api-token'].nil?

    if ApiToken.find_by(value: request.headers['x-api-token']).nil?
      render json: { message: :invalid_api_token }, status: :unauthorized
    end
  end

  def redirect_if_authenticated!
    redirect_to root_url if authenticated?
  end

  def authenticated?
    !session[:user_id].nil?
  end

  def current_user
    @current_user ||= User.find session[:user_id] if authenticated?
  end

  helper_method :authenticated?, :current_user

  # Http helpers
  def forbidden
    @message = '403: HTTP_FORBIDDEN'
    render 'error/base', status: :forbidden
  end

  def not_found
    @message = '404: HTTP_NOT_FOUND'
    render 'error/base', status: :not_found
  end

  def internal_server_error
    @message = '500: HTTP_INTERNAL_SERVER_ERROR'
    render 'error/base', status: :internal_server_error
  end

  rescue_from CanCan::AccessDenied, with: :forbidden
end
