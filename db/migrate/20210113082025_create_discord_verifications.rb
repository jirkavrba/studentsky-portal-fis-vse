class CreateDiscordVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_verifications do |t|
      t.integer :user_id, unique: true, null: true
      t.integer :discord_id, unique: true
      t.string :challenge_code, unique: true
      t.string :verification_code, unique: true

      t.timestamps
    end
  end
end
