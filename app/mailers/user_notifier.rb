class UserNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_notifier.verification_mail.subject
  #

  # just name as verification_mail
  def verification_mail(user)
    @user = user
    mail to: user.email , subject: 'FlashSale Account Verification'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_notifier.send_password_change_token.subject
  #

  #same as above
  def send_password_change_token
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
