# frozen_string_literal: true

class CreateUserVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :user_verifications do |t|
      t.integer  :user_id, unique: true
      t.string   :verification_code

      t.timestamps
    end
  end
end
