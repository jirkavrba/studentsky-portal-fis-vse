# frozen_string_literal: true

class DiscordVerification < ApplicationRecord
  belongs_to :user
end
