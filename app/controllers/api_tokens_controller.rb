# frozen_string_literal: true

class ApiTokensController < ApplicationController
  before_action :authenticate!
  before_action :require_admin_privileges!
end
