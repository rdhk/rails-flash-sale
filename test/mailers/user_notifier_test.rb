require 'test_helper'

class UserNotifierTest < ActionMailer::TestCase
  test "send_verification_token" do
    mail = UserNotifier.send_verification_token
    assert_equal "Send verification token", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "send_password_change_token" do
    mail = UserNotifier.send_password_change_token
    assert_equal "Send password change token", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
