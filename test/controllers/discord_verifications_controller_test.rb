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

    get complete_discord_verification_url(code: verification.code, discord_id: 238728915647070209)
    assert_response :unprocessable_entity
  end

  test 'users cannot verify multiple accounts' do
    verification = discord_verifications(:already_verified)

    get complete_discord_verification_url(code: verification.code, discord_id: verification.discord_id)
    assert_response :unprocessable_entity
  end
end
