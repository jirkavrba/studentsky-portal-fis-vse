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

  def ban
    return redirect_to user_url(@user), notice: 'Nelze zabanovat administrátora.' if @user.is_admin

    @user.update is_banned: true

    redirect_to user_url(@user)
  end

  def unban
    @user.update is_banned: false

    redirect_to user_url(@user)
  end

  def destroy
    return redirect_to user_url(@user), notice: 'Nelze smazat účet administrátora.' if @user.is_admin

    @user.delete

    redirect_to users_url
  end

  private

  def authorize
    authorize! :manage, :users
  end

  def set_user
    @user = User.find params[:id]
  end
end
