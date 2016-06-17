# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  house_no   :string(255)
#  street     :string(255)
#  city       :string(255)
#  pincode    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_addresses_on_user_id  (user_id)
#

class Address < ActiveRecord::Base
  belongs_to :user
  has_many :orders
  validates :house_no, :street, :city, :pincode, presence: true
  validates :pincode, numericality: true, length: {is: 6}
end
