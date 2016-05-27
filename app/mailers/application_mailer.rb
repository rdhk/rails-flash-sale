class ApplicationMailer < ActionMailer::Base
  #FIXME_AB:  move configuration to application.yml
  default from: "radhika@vinsol.com"
  layout 'mailer'
end
