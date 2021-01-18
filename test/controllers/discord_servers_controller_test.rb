require "test_helper"

class DiscordServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @discord_server = discord_servers(:one)
    sign_in_as :admin_user
  end

  test "should get index" do
    get discord_servers_url
    assert_response :success
  end

  test "should get new" do
    get new_discord_server_url
    assert_response :success
  end

  test "should create discord_server" do
    assert_difference('DiscordServer.count') do
      post discord_servers_url, params: {
        discord_server: {
          embed_url: @discord_server.embed_url,
          invite_url: @discord_server.invite_url,
          priority: @discord_server.priority
        }
      }
    end

    assert_redirected_to discord_server_url(DiscordServer.last)
  end

  test "should show discord_server" do
    get discord_server_url(@discord_server)
    assert_response :success
  end

  test "should get edit" do
    get edit_discord_server_url(@discord_server)
    assert_response :success
  end

  test "should update discord_server" do
    patch discord_server_url(@discord_server), params: {
      discord_server: {
        embed_url: @discord_server.embed_url,
        invite_url: @discord_server.invite_url,
        priority: @discord_server.priority }
    }
    assert_redirected_to discord_server_url(@discord_server)
  end

  test "should destroy discord_server" do
    assert_difference('DiscordServer.count', -1) do
      delete discord_server_url(@discord_server)
    end

    assert_redirected_to discord_servers_url
  end
end
