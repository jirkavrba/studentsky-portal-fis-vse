class ApplicationController < ActionController::Base
  helper_method :authenticated?, :current_user

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
end
