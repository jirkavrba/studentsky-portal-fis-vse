class AuthenticationMailer < ApplicationMailer
  before_action :set_user

  def verification_email
    mail to: "#{@user.username}@vse.cz", subject: 'Aktivace účtu na studentském portálu.'
  end

  private

  def set_user
    @user = params[:user]
  end
end