class ApplicationMailer < ActionMailer::Base
  #FIXME_AB:  move configuration to application.yml
  default from: CONSTANTS["default_email_from"]
  layout 'mailer'
end
