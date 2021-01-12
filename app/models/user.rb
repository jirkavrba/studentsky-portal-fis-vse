class User < ApplicationRecord
  has_secure_password

  has_one :email_verification

  validates :username, presence: true, uniqueness: true, format: { with: /\A[0-9a-z]+\z/ }

  def display_name
    name.empty? ? username : name
  end
end
