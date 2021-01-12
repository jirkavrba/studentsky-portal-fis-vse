class User < ApplicationRecord
  has_secure_password

  has_one :user_verification

  validates :username, presence: true, uniqueness: true, format: { with: /\A[0-9a-z]+\z/ }
  validates_length_of :password, minimum: 8, allow_blank: false

  def display_name
    name || username
  end
end
