# frozen_string_literal: true

class UserVerification < ApplicationRecord
  validate :user_id, exists?(:users)
end
