class User < ActiveRecord::Base
  has_secure_password

  attr_accessor :password_required

  scope :verified, -> {where.not(verified_at: nil)}

  validates :first_name, :last_name, :email, presence: true
  validates :password, length: { minimum: 6 }, if: "password_required.present?"
  validates :email, format: { with: REGEX[:email] }
  #FIXME_AB: always think for case sensitivity when you use uniqueness
  validates :email, uniqueness: true, case_sensitive: false

  after_commit :send_verification_email, on: :create, if: "!admin"
  before_create :generate_verification_token, if: "!admin"
  before_validation :set_password_required, on: :create


  def valid_authenticity_token?
    verification_token_expires_at >= Time.current
  end

  def verified?
    verified_at.present?
  end

  def mark_verified!
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expires_at = nil
    save!
  end

  def generate_token_and_save(column)
    generate_token(column)
    save
  end

  def fulfill_forgot_password_request
    generate_token(:password_change_token)
    #FIXME_AB: Don't hardcode 3. 3.hours.from_now
    self.password_token_expires_at = PASSWORD_TOKEN_EXPIRES_IN.hours.from_now
    save!
    UserNotifier.password_reset(self).deliver
  end

  def change_password(password, password_confirmation)
    self.password_required = true
    self.password = password
    self.password_confirmation = password_confirmation
    self.password_change_token = nil
    self.password_token_expires_at = nil
    save
  end

  def clear_remember_token!
    self.remember_me_token = nil
    save!
  end

  def has_valid_password_token?
    password_token_expires_at >= Time.current
  end

  private

  def set_password_required
    if(password.present?)
      self.password_required = true
    end
  end

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
