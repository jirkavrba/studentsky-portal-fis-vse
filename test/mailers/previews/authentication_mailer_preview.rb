# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/authentication_mailer
class AuthenticationMailerPreview < ActionMailer::Preview
  def verification_email
    user = User.new username: 'vrbj04', name: 'Jiří Vrba', password_digest: 'something', is_verified: false
    user.email_verification = EmailVerification.new verification_code: SecureRandom.hex(32)

    AuthenticationMailer.with(user: user).verification_email
  end

  def password_reset_email
    user = User.new username: Digest::RMD160.hexdigest('vrbj04'),
                    name: 'Jiří Vrba',
                    password_digest: 'something',
                    is_verified: true,
                    password_reset_token: SecureRandom.urlsafe_base64(128)


    AuthenticationMailer.with(user: user, username: 'vrbj04').password_reset_email
  end
end
