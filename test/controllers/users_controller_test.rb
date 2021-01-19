# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'admins can view users listing' do
    sign_in_as :admin_user

    get users_url
    assert_response :success
  end

  test 'admins can manage user settings' do
    sign_in_as :admin_user

    get user_url(users(:verified_user))
    assert_response :success
  end

  test 'guests cannot view users listing' do
    sign_out

    get users_url
    assert_redirected_to sign_in_url
  end

  test 'guests cannot manage user settings' do
    sign_out

    get user_url(users(:verified_user))
    assert_redirected_to sign_in_url
  end

  test 'users cannot view users listing' do
    sign_in_as :verified_user

    get users_url
    assert_response :forbidden
  end

  test 'users cannot manage other users settings' do
    sign_in_as :verified_user

    get user_url(users(:admin_user))
    assert_response :forbidden
  end

  test 'users can manage their own settings' do
    sign_in_as :verified_user

    get user_url(users(:verified_user))
    assert_response :success
  end

  test 'users can change their name in account settings' do
    sign_in_as :verified_user

    user = users(:verified_user)

    patch user_url(user), params: {
      user: {
        name: 'New name'
      }
    }

    assert_redirected_to user_url(user)
    assert_equal 'Změny byly uloženy.', flash[:notice]

    assert_equal 'New name', user.reload.name
  end

  test 'changing one users changes only that user' do
    sign_in_as :verified_user

    user = users(:verified_user)

    patch user_url(user), params: {
      user: {
        name: 'New name'
      }
    }

    assert_equal 'New name', user.reload.name
    assert_not_equal 'New name', users(:admin_user).name
  end

  test 'users can change their password in account settings' do
    sign_in_as :verified_user

    user = users(:verified_user)
    password = SecureRandom.hex(10)

    patch user_url(user), params: {
      user: {
        password: password
      }
    }

    assert_redirected_to user_url(user)
    assert_equal 'Změny byly uloženy.', flash[:notice]

    # The password was changed...
    assert user.reload.authenticate(password)
  end
end
