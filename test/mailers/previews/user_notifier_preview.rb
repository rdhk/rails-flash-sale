# Preview all emails at http://localhost:3000/rails/mailers/user_notifier
class UserNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_notifier/send_verification_token
  def send_verification_token
    UserNotifier.send_verification_token
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_notifier/send_password_change_token
  def send_password_change_token
    UserNotifier.send_password_change_token
  end

end
