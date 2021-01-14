require "test_helper"

class DiscordVerificationsControllerTest < ActionDispatch::IntegrationTest

  test 'guest users cannot view their code' do
    sign_out

    get discord_verification_url
    assert_redirected_to sign_in_path
  end

  test 'users that are not discord-verified can view their code' do
    sign_in_as(:verified_user)

    get discord_verification_url
    assert_response :success
    assert_match "+verify #{discord_verifications(:verified_user).code}", response.body
  end

  test 'banned users cannot verify their discord account' do
    verification = discord_verifications(:banned_user)

    post complete_discord_verification_url(code: verification.code, discord_id: 238728915647070209),
         params: { api_token: api_tokens(:default).value }

    assert_response :unprocessable_entity
  end

  test 'users cannot verify multiple accounts' do
    verification = discord_verifications(:already_verified)

    post complete_discord_verification_url(code: verification.code, discord_id: verification.discord_id),
         params: { api_token: api_tokens(:default).value }

    assert_response :unprocessable_entity
  end

  test 'users cannot verify account without API token' do
    verification = discord_verifications(:verified_user)

    post complete_discord_verification_url(code: verification.code, discord_id: 238728915647070209)
    assert_response :unauthorized
  end

  test 'user verifications can be checked' do
    verification = discord_verifications(:already_verified)

    get check_discord_verification_url(discord_id: verification.discord_id), params: { api_token: api_tokens(:default).value }
    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 'admin', body['username']
    assert_equal 'admin@vse.cz', body['email']
  end

  test 'missing user verifications cannot be checked' do
    get check_discord_verification_url(discord_id: 42069), params: { api_token: api_tokens(:default).value }
    assert_response :not_found
  end
end
