# frozen_string_literal: true

class CreateApiTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :api_tokens do |t|
      t.string :value, unique: true

      t.timestamps
    end
  end
end
