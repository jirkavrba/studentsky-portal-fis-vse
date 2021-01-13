class UsersController < ApplicationController
  before_action :authenticate!
  before_action :authorize
  before_action :set_user, except: [:index]

  def index
    @users = User.order(is_admin: :desc, is_verified: :desc).all
  end

  def show
    @avatar_url = Digest::MD5.hexdigest("#{@user.username}@vse.cz")
  end

  private

  def authorize
    authorize! :manage, :users
  end

  def set_user
    @user = User.find params[:id]
  end
end
