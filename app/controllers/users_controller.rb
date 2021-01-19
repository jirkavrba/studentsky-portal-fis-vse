# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate!
  before_action :set_user, except: [:index]

  def index
    authorize! :read, :users

    @users = User.order(is_admin: :desc, is_verified: :desc).all
  end

  def ban
    authorize! :ban, @user

    return redirect_to user_url(@user), alert: 'Nelze zabanovat administrátora.' if @user.is_admin

    @user.update is_banned: true
    redirect_to user_url(@user), notice: "Uživatel #{@user.display_name} byl zabanován."
  end

  def unban
    authorize! :unban, @user

    @user.update is_banned: false
    redirect_to user_url(@user), notice: "Uživatel #{@user.display_name} byl odbanován."
  end

  def destroy
    authorize! :destroy, @user

    return redirect_to user_url(@user), alert: 'Nelze smazat účet administrátora.' if @user.is_admin

    @user.delete
    redirect_to users_url, notice: "Uživatel #{@user.display_name} byl smazán."
  end

  def show
    authorize! :view, @user
  end

  def edit
    authorize! :manage, @user
  end

  def update
    authorize! :manage, @user

    @user.update user_params

    redirect_to user_url(@user), notice: 'Změny byly uloženy.'
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:name, :avatar_discriminator, :password)
  end
end
