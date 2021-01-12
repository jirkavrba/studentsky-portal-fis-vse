# frozen_string_literal: true

class RenameUserVerificationToEmailVerification < ActiveRecord::Migration[6.1]
  def change
    rename_table :user_verifications, :email_verifications
  end
end
