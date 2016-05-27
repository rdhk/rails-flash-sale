class UserNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_notifier.verification_mail.subject
  #

  def verification_mail(user)
    @user = user
    mail to: user.email , subject: 'FlashSale Account Verification'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_notifier.send_password_change_token.subject
  #

  def password_reset(user)
    @user = user
    mail to: user.email , subject: 'FlashSale Password Reset Instructions'
  end
end
