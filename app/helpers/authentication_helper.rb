# frozen_string_literal: true

module AuthenticationHelper
  def signed_in?
    !session[:user_id].nil?
  end

  def current_user
    #noinspection RailsChecklist05
    @current_user ||= User.find session[:user_id]
  end
end
