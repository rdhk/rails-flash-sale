class ApplicationMailer < ActionMailer::Base
  default from: CONSTANTS["default_email_from"]
  layout 'mailer'
end
