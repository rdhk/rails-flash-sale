# == Schema Information
#
# Table name: users
#
#  id                            :integer          not null, primary key
#  first_name                    :string(255)      not null
#  last_name                     :string(255)      not null
#  email                         :string(255)      not null
#  password_digest               :string(255)      not null
#  admin                         :boolean          default(FALSE)
#  verification_token            :string(255)
#  verification_token_expires_at :datetime
#  verified_at                   :datetime
#  password_change_token         :string(255)
#  password_token_expires_at     :datetime
#  remember_me_token             :string(255)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  auth_token                    :string(255)
#
# Indexes
#
#  index_users_on_email  (email)
#

class User < ActiveRecord::Base
  has_secure_password

  attr_accessor :password_required


  validates :first_name, :last_name, :email, presence: true
  validates :password, length: { minimum: 6 }, if: "password_required.present?"
  validates :email, format: { with: REGEX[:email] }
  validates :email, uniqueness: true, case_sensitive: false

  has_many :published_deals, class_name: "Deal", foreign_key: "publisher_id"
  has_many :created_deals, class_name: "Deal", foreign_key: "creator_id"
  has_many :orders, dependent: :restrict_with_error
  has_many :paid_orders, -> { where status: Order.statuses[:paid] }, class_name: "Order"
  has_many :purchased_deals, through: :paid_orders, source: "deals"
  has_many :payment_transactions, dependent: :restrict_with_error
  has_many :addresses, dependent: :destroy

  scope :verified, -> {where.not(verified_at: nil)}

  after_commit :send_verification_email, on: :create, if: "!admin"
  before_create :generate_verification_token, if: "!admin"
  before_validation :set_password_required, on: :create

  def loyalty_discount_rate
    #FIXME_AB: this should be orders.delivered.count after we have delivered
    orders_count = orders.paid.count
    if orders_count < 1
      return 0
    elsif orders_count >= 6
      return CONSTANTS["max_loyalty_discount_rate"]
    else
      return orders_count
    end
  end

  def get_current_order
    order = orders.pending.first

    if(order.nil?)
      order = orders.build
    else
      order.clear_expired_deals
    end

    order
  end

  def valid_verification_token?
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
    self.password_token_expires_at = CONSTANTS[password_token_expires_in].hours.from_now
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
    self.verification_token_expires_at = Time.current + CONSTANTS["verification_token_expiration_time"].hours
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
