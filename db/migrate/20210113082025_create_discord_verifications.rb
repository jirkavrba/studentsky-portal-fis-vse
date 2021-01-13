class CreateDiscordVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_verifications do |t|
      t.integer :user_id, unique: true, null: true
      t.string  :discord_id, unique: true, null: true
      t.string  :code, unique: true

      t.timestamps
    end
  end
end
