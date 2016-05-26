class ApplicationMailer < ActionMailer::Base
  # move configuration to application.yml
  default from: "radhika@vinsol.com"
  layout 'mailer'
end
