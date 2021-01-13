# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Authentication
  def authenticate!
    redirect_to sign_in_url unless authenticated?
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
    render text: '403: HTTP_FORBIDDEN', status: :forbidden
  end

  def not_found
    render text: '404: HTTP_NOT_FOUND', status: :not_found
  end

  def internal_server_error
    render text: '500: INTERNAL_SERVER_ERROR', status: :internal_server_error
  end

  rescue_from CanCan::AccessDenied, with: :forbidden
end
