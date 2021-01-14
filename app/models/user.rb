class User < ApplicationRecord
  has_secure_password

  has_one :email_verification
  has_one :discord_verification

  extend Blacklist

  validates :username, presence: true,
                       uniqueness: true,
                       format: { with: /\A[0-9a-z]+\z/ },
                       exclusion: { in: blacklist }

  def display_name
    name.empty? ? username : name
  end
end
