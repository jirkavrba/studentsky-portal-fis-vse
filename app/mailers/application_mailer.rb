# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'bot@portal.fis-vse.cz'
  layout 'mailer'
end
