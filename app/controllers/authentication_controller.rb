# frozen_string_literal: true

class AuthenticationController < ApplicationController
  def login; end

  def registration
    @user = User.new
  end

  def process_login
    login_params = params.permit(:username, :password)
    user = User.find_by username: login_params[:username]

    if user.nil? || !user.authenticate(login_params[:password])
      return redirect_to sign_in_url, alert: 'Nesprávné přihlašovací údaje nebo uživatel neexistuje.'
    end

    unless user.is_verified
      return redirect_to sign_in_url, alert: 'Tento účet ještě nebyl aktivován pomocí odkazu v emailu.'
    end

    if Rails.env.production? && !verify_hcaptcha(model: @user)
      return redirect_to sign_up_url, alert: "Nevyplněná ochrana proti robotům."
    end

    session[:user_id] = user.id

    redirect_to root_url, notice: "Přihlášen jako #{user.display_name}"
  end

  def process_registration
    registration_params = params.require(:user).permit(:username, :name, :password)
    user = User.new registration_params

    if user.valid?
      user.email_verification = EmailVerification.new verification_code: SecureRandom.hex(32)
      user.save!

      AuthenticationMailer.with(user: user).verification_email.deliver_later

      redirect_to sign_in_url, notice: "Na email #{user.username}@vse.cz byl odeslán aktivační odkaz."
    else
      redirect_to sign_up_url, alert: user.errors.full_messages
    end
  end

  def verify_email
    code = params[:code]
    verification = EmailVerification.find_by verification_code: code

    if verification.nil?
      return redirect_to sign_in_url, alert: 'Neplatný aktivační odkaz.'
    end

    verification.user.update! is_verified: true
    verification.delete

    redirect_to sign_in_url, notice: "Účet #{verification.user.display_name} byl aktivován a je nyní možné se přihlásit."
  end
end
