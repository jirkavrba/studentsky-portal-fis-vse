# frozen_string_literal: true

json.array! @discord_servers, partial: 'discord_servers/discord_server', as: :discord_server
