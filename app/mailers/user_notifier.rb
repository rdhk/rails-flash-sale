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
  def order_confirmation_mail(order)
    @order = order
    #FIXME_AB: you don't nee @user variable use order.user - done
    @user = order.user
    #FIXME_AB: subject: include the order number - done
    mail to: @user.email, subject: 'FlashSale Order Confirmation for order #<%= order.id.to_s %>'
  end

  def password_reset(user)
    @user = user
    mail to: user.email , subject: 'FlashSale Password Reset Instructions'
  end
end
