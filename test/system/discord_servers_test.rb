require "application_system_test_case"

class DiscordServersTest < ApplicationSystemTestCase
  setup do
    @discord_server = discord_servers(:one)
  end

  test "visiting the index" do
    visit discord_servers_url
    assert_selector "h1", text: "Discord Servers"
  end

  test "creating a Discord server" do
    visit discord_servers_url
    click_on "New Discord Server"

    fill_in "Embed url", with: @discord_server.embed_url
    fill_in "Priority", with: @discord_server.priority
    click_on "Create Discord server"

    assert_text "Discord server was successfully created"
    click_on "Back"
  end

  test "updating a Discord server" do
    visit discord_servers_url
    click_on "Edit", match: :first

    fill_in "Embed url", with: @discord_server.embed_url
    fill_in "Priority", with: @discord_server.priority
    click_on "Update Discord server"

    assert_text "Discord server was successfully updated"
    click_on "Back"
  end

  test "destroying a Discord server" do
    visit discord_servers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Discord server was successfully destroyed"
  end
end
