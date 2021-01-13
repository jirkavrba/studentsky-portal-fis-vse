class UsersController < ApplicationController
  before_action :authenticate!
  before_action :authorize

  def index
    @users = User.order(is_admin: :desc, is_verified: :desc).all
  end

  private

  def authorize
    authorize! :manage, :users
  end
end
