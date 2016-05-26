class User < ActiveRecord::Base
  has_secure_password

  attr_accessor :password_required

  validates :first_name, :last_name, :email, presence: true
  validates :password, length: { minimum: 6 }, if: "password_required.present?"
  # validates :email, uniqueness: true
  # password should be min 6 chars

  after_commit :send_verification_email, on: :create
  before_create :generate_verification_token

  def valid_authenticity_token?
    verification_token_expires_at >= Time.current
  end

  #FIXME_AB:  not needed
  def is_valid?(password)
    verified? && authenticate(password)
  end

  def verified?
    verified_at.present?
  end

  #FIXME_AB: mark_verified!
  def mark_verified
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expires_at = nil
    save!
  end

  def generate_token_and_save(column)
    generate_token(column)
    save
  end


  # def generate_remembrance_token
  #   generate_token(:remember_me_token)
  #   save
  # end

  # def generate_forgot_password_token
  #   generate_token(:remember_me_token)
  #   save
  # end

  def handle_forgot_password
    generate_token(:password_change_token)
    #FIXME_AB: Don't hardcode 3
    self.password_token_expires_at = Time.current + 3.hours
    save
    UserNotifier.password_reset(self).deliver
  end

  def change_password(password)
    self.password = password
    self.password_change_token = nil
    self.password_token_expires_at = nil
    save
  end

  #FIXME_AB: !
  def clear_remember_token
    self.remember_me_token = nil
    save
  end

  def has_valid_password_token
    password_token_expires_at >= Time.current
  end

  private

  def generate_verification_token
    generate_token(:verification_token)
    self.verification_token_expires_at = Time.current + 6.hours
  end

  def send_verification_email
    UserNotifier.verification_mail(self).deliver
  end

  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      if(!User.exists?(column => self[column]))
        break
      end
    end
  end

end

