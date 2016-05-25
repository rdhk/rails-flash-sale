class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, :last_name, :email, presence: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  # validates :email, uniqueness: true
  # password should be min 6 chars

  after_commit :send_verification_email, on: :create
  before_create :generate_verification_token

  def valid_authenticity_token?
    verification_token_expires_at >= Time.current
  end

  def mark_verified
    self.verified_at = Time.current
    self.verification_token = nil
    self.verification_token_expires_at = nil
    save
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
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end

