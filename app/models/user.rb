# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :email_verification
  has_one :discord_verification

  extend Blacklist

  validates :username, presence: true,
                       format: { with: /\A[0-9a-z]+\z/ },
                       exclusion: { in: blacklist }

  validate :unique_username

  def display_name
    name.empty? ? username.truncate(16) : name
  end

  def unique_username
    User.where(username: username)
        .or(User.where(username: Digest::RMD160.hexdigest(username)))
        .none?
  end
end
