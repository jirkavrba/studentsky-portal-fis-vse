# frozen_string_literal: true

class AuthenticationController < ApplicationController
  before_action :redirect_if_authenticated!, except: [:logout]

  def login; end

  def registration
    @user = User.new
  end

  def process_login
    login_params = params.permit(:username, :password)
    user = User.find_by username: Digest::RMD160.hexdigest(login_params[:username])

    unless user.present? && user.authenticate(login_params[:password])
      return redirect_to sign_in_url, alert: 'Nesprávné přihlašovací údaje nebo účet nebyl aktivován odkazem v emailu.'
    end

    # Failsafe to prevent users registering with Ripemd160 hashes as their usernames
    unless user.is_verified
      return redirect_to sign_in_url, alert: 'Tento účet ještě nebyl aktivován pomocí odkazu v emailu.'
    end

    if user.is_banned
      return redirect_to sign_in_url, alert: 'Tento účet byl zablokován administrátory a není možné se přihlásit.'
    end

    session[:user_id] = user.id

    redirect_to root_url, notice: "Přihlášen jako #{user.display_name}"
  end

  def process_registration
    if Rails.env.production? && !verify_hcaptcha(model: @user)
      return redirect_to sign_up_url, alert: 'Nevyplněná ochrana proti robotům.'
    end

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

  def logout
    session[:user_id] = nil
    redirect_to root_url, notice: 'Odhlášení proběhlo úspěšně.'
  end

  def verify_email
    code = params[:code]
    verification = EmailVerification.find_by verification_code: code

    return redirect_to sign_in_url, alert: 'Neplatný aktivační odkaz.' if verification.nil?

    # TODO: Maybe add database index to usernames and update it here for better performance
    verification.user.update! is_verified: true, username: Digest::RMD160.hexdigest(verification.user.username)
    verification.delete

    redirect_to sign_in_url, notice: "Účet #{verification.user.display_name} byl aktivován a je nyní možné se přihlásit."
  end

  def new_verification_email; end

  def new_password_reset_request; end

  def process_new_verification_email
    verification_params = params.permit(:username, :password)

    if Rails.env.production? && !verify_hcaptcha(model: @user)
      return redirect_to new_verification_url, alert: 'Nevyplněná ochrana proti robotům.'
    end

    user = User.find_by username: verification_params[:username]

    if user.nil? || !user.authenticate(verification_params[:password])
      return redirect_to sign_in_url, alert: 'Nesprávné přihlašovací údaje nebo uživatel neexistuje.'
    end

    return redirect_to sign_in_url, alert: 'Tento účet je již aktivován.' if user.is_verified

    # upsert = insert or update, this was added in Rails 6
    user.email_verification ||= EmailVerification.new
    user.email_verification.update verification_code: SecureRandom.hex(32)
    user.save!

    AuthenticationMailer.with(user: user).verification_email.deliver_later

    redirect_to sign_in_url,
                notice: "Na email #{user.username}@vse.cz byl odeslán nový aktivační odkaz. Původní odkaz byl tímto zneplatněn."
  end

  def process_password_reset_request
    password_reset_params = params.permit(:username)

    if Rails.env.production? && !verify_hcaptcha(model: @user)
      return redirect_to reset_password_url, alert: 'Nevyplněná ochrana proti robotům.'
    end

    user = User.find_by username: Digest::RMD160.hexdigest(password_reset_params[:username])

    if user.nil?
      return redirect_to reset_password_url, alert: 'Uživatel neexistuje nebo nebyl účet nebyl ještě aktivován.'
    end

    unless user.password_reset_token.nil?
      return redirect_to reset_password_url, alert: 'Tento účet má již aktivní žádost o obnovení hesla.'
    end

    user.password_reset_token = SecureRandom.urlsafe_base64(128)
    user.save!

    # Username must be explicitly passed to the mailer, as the username stored is hashed and cannot be used
    AuthenticationMailer.with(user: user, username: password_reset_params[:username]).password_reset_email.deliver_later

    redirect_to sign_in_url, notice: "Na email #{password_reset_params[:username]}@vse.cz byl odeslán odkaz pro obnovení hesla."
  end

  def process_password_reset
    user = User.find_by password_reset_token: params[:code]

    if user.nil?
      return redirect_to sign_in_url, alert: 'Neplatný odkaz.'
    end

    user.password_reset_token = nil
    user.save!

    session[:user_id] = user.id

    redirect_to edit_user_url(user), notice: "Dočasně přihlášen jako #{user.display_name}, nyní je možné nastavit si nové heslo."
  end
end
