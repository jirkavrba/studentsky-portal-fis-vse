class CreateDiscordServers < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_servers do |t|
      t.string :embed_url
      t.string :invite_url
      t.integer :priority

      t.timestamps
    end
  end
end
