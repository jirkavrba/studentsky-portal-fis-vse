# frozen_string_literal: true

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
    return redirect_to user_url(@user), alert: 'Nelze zabanovat administrátora.' if @user.is_admin

    @user.update is_banned: true
    redirect_to user_url(@user), notice: "Uživatel #{@user.display_name} byl zabanován."
  end

  def unban
    @user.update is_banned: false
    redirect_to user_url(@user), notice: "Uživatel #{@user.display_name} byl odbanován."
  end

  def destroy
    return redirect_to user_url(@user), alert: 'Nelze smazat účet administrátora.' if @user.is_admin

    @user.delete
    redirect_to users_url, notice: "Uživatel #{@user.display_name} byl smazán."
  end

  private

  def authorize
    authorize! :manage, :users
  end

  def set_user
    @user = User.find params[:id]
  end
end
