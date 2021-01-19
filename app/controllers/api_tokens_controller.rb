# frozen_string_literal: true

class ApiTokensController < ApplicationController
  before_action :authenticate!
  before_action :require_admin_privileges!

  def index
    @tokens = ApiToken.all
  end

  def new
    @token = ApiToken.new value: SecureRandom.urlsafe_base64(64)
    @token.save!

    redirect_to api_tokens_url
  end

  def destroy
    @token = ApiToken.find params[:id]
    @token.delete

    redirect_to api_tokens_url
  end
end
