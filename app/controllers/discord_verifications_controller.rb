# frozen_string_literal: true

class DiscordVerificationsController < ApplicationController
  before_action :authenticate!

  def show_code
    @verification = current_user.discord_verification || DiscordVerification.new(user_id: current_user.id,
                                                                                 code: SecureRandom.hex(16))
    @verification.save!
  end
end
