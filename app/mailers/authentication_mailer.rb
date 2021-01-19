# frozen_string_literal: true

class AuthenticationMailer < ApplicationMailer
  before_action :set_user

  def verification_email
    mail to: "#{@user.username}@vse.cz", subject: 'Aktivace účtu na studentském portálu.'
  end

  def password_reset_email
    mail to: "#{params[:username]}@vse.cz", subject: 'Obnovení hesla na studentském portálu.'
  end

  private

  def set_user
    @user = params[:user]
  end
end
