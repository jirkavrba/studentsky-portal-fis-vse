# frozen_string_literal: true

require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test 'verified users can sign in' do
    sign_out

    user = users(:verified_user)

    post sign_in_url, params: {
      username: user.name,
      password: 'verified_user'
    }

    assert_equal "Přihlášen jako #{user.display_name}", flash[:notice]
    assert_redirected_to root_url

    get root_url

    assert_response :success
    assert_match user.display_name, response.body

    assert_equal user.id, session[:user_id]
  end

  test 'non-verified but existing users cannot sign in' do
    sign_out

    user = users(:non_verified_user)

    post sign_in_url, params: {
      username: user.username,
      password: 'non_verified_user'
    }

    assert_equal 'Nesprávné přihlašovací údaje nebo účet nebyl aktivován odkazem v emailu.', flash[:alert]
    assert_redirected_to sign_in_url

    assert_nil session[:user_id]
  end

  test 'banned users cannot sign in' do
    sign_out

    post sign_in_url, params: {
      username: 'badb0i',
      password: 'banned_user'
    }

    assert_equal 'Tento účet byl zablokován administrátory a není možné se přihlásit.', flash[:alert]
    assert_redirected_to sign_in_url

    assert_nil session[:user_id]
  end

  test 'signed in users cannot see login form until logout' do
    sign_in_as :verified_user

    get sign_in_url
    assert_redirected_to root_url
  end

  test 'signed in users cannot see registration form until logout' do
    sign_in_as :verified_user

    get sign_up_url
    assert_redirected_to root_url
  end

  test 'users cannot sign in with wrong credentials' do
    sign_out

    post sign_in_url, params: {
      username: 'verified_user',
      password: 'somebody_once_told_me'
    }

    assert_equal 'Nesprávné přihlašovací údaje nebo účet nebyl aktivován odkazem v emailu.', flash[:alert]
    assert_redirected_to sign_in_url

    post sign_in_url, params: {
      username: 'the_world_is_gonna_roll_me',
      password: 'I_aint_the_sharpest_tool_in_the_shed'
    }

    assert_equal 'Nesprávné přihlašovací údaje nebo účet nebyl aktivován odkazem v emailu.', flash[:alert]
    assert_redirected_to sign_in_url
  end

  test 'users cannot register an already existing account' do
    sign_out

    post sign_up_url, params: {
      user: {
        username: 'non_verified_user',
        name: 'Rick Astley',
        password: 'never_gonna_give_you_up'
      }
    }

    assert_redirected_to sign_up_url
  end

  test 'users can register and activate a new account' do
    sign_out

    post sign_up_url, params: {
      user: {
        username: 'vrbj04',
        name: 'Jiří Vrba',
        password: 'never_gonna_let_you_down'
      }
    }

    assert_redirected_to sign_in_url
    assert_equal 'Na email vrbj04@vse.cz byl odeslán aktivační odkaz.', flash[:notice]

    user = User.find_by username: 'vrbj04'

    assert_not_nil user
    assert_not_nil user.email_verification

    assert_not user.is_verified

    # TODO: Connect action mailer interceptor to test email was really sent?

    get verification_url(user.email_verification.verification_code)
    assert_redirected_to sign_in_url

    assert_equal 'Účet Jiří Vrba byl aktivován a je nyní možné se přihlásit.', flash[:notice]

    user.reload

    assert user.is_verified
    assert_nil user.email_verification

    # Validate that username is hashed after a successful verification
    assert_nil User.find_by username: 'vrbj04'
    assert_not_nil User.find_by username: Digest::RMD160.hexdigest('vrbj04')
  end

  test 'blacklisted users cannot sign up their account' do
    sign_out

    # Note that this is not personal, just a representative sample
    blacklisted = %w[adaa04 adamek advorak aled02 alga01 alin00 andrlikh antj00 arltova arlt]

    blacklisted.each do |username|
      post sign_up_url, params: {
        user: {
          username: username,
          name: '',
          password: SecureRandom.hex(30)
        }
      }

      assert_redirected_to sign_up_url
    end
  end

  test 'users must have unique usernames, even when ripemd hashed' do
    # This user is verified and therefore hashed in the database
    post sign_up_url, params: {
      user: {
        username: 'verified_user',
        password: 'verified_user'
      }
    }

    assert_redirected_to sign_up_url
    assert_equal ['Username is invalid'], flash[:alert]

    # This user is not verified yet and therefore plaintext in the database
    post sign_up_url, params: {
      user: {
        username: 'non_verified_user',
        password: 'non_verified_user'
      }
    }

    assert_redirected_to sign_up_url
    assert_equal ['Username is invalid'], flash[:alert]
  end

  test 'users can reset their password' do
    sign_out

    post reset_password_url, params: {
      username: 'admin'
    }

    assert_nil flash[:alert]
    assert_equal 'Na email admin@vse.cz byl odeslán odkaz pro obnovení hesla.', flash[:notice]
    assert_redirected_to sign_in_url
  end

  test 'users cannot reset their password with invalid username' do
    sign_out

    post reset_password_url, params: {
      username: 'not_actually_a_verified_user'
    }

    assert_redirected_to reset_password_url
    assert_equal 'Uživatel neexistuje nebo nebyl účet nebyl ještě aktivován.', flash[:alert]
  end

  test 'valid code will sign you in' do
    sign_out

    user = users(:verified_user)

    get password_reset_url(code: user.password_reset_token)

    assert_equal 'Dočasně přihlášen jako verified_user, nyní je možné nastavit si nové heslo.', flash[:notice]
    assert_equal user.id, session[:user_id]

    assert_nil user.reload.password_reset_token
  end
end
