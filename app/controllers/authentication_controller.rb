class AuthenticationController < ApplicationController
  def login
    @user = User.new
  end
end
