class ApplicationMailer < ActionMailer::Base
  # move configuration to application.yml
  default from: "from@example.com"
  layout 'mailer'
end
