# frozen_string_literal: true

class DiscordVerificationsController < ApplicationController
  before_action :authenticate!, only: [:show_code]
  before_action :require_valid_api_token!, except: [:show_code]

  # Disable authenticity_token check which causes API request to fail
  skip_before_action :verify_authenticity_token, except: [:show_code]

  def show_code
    @verification = current_user.discord_verification || DiscordVerification.new(user_id: current_user.id,
                                                                                 code: SecureRandom.hex(16))
    @verification.save!
  end

  def complete
    verification = DiscordVerification.find_by code: params[:code]

    if verification.nil?
      return render json: { status: :verification_entry_not_found,
                            message: 'There is no active verification with the specified code.' },
                    status: :not_found
    end

    if verification.discord_id.present?
      return render json: { status: :verification_code_already_user,
                            message: 'This verification code was already used.' },
                    status: :unprocessable_entity
    end

    if verification.user.is_banned
      return render json: { status: :user_banned,
                            message: 'User with this verification code was banned and therefore cannot be verified.' },
                    status: :unprocessable_entity
    end

    verification.discord_id = params[:discord_id]
    verification.save!

    render json: { status: :verified,
                   message: 'Account verified.',
                   username: user.username }
  end

  def check
    verification = DiscordVerification.find_by discord_id: params[:discord_id]

    if verification.nil?
      return render json: { status: :verification_entry_not_found,
                            message: 'There is no active verification with the specified code.' },
                    status: :not_found
    end

    render json: { username: verification.user.username,
                   email: "#{verification.user.username}@vse.cz" }
  end
end
