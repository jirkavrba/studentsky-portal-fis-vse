# frozen_string_literal: true

json.extract! discord_server, :id, :embed_url, :priority, :created_at, :updated_at
json.url discord_server_url(discord_server, format: :json)
