# == Schema Information
#
# Table name: images
#
#  id                :integer          not null, primary key
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  deal_id           :integer
#

class Image < ActiveRecord::Base
  #FIXME_AB: read about imagemagic geometric string
  has_attached_file :file, styles: { medium: "300x300>", thumb: "100x100>" }

  #FIXME_AB: show these content types to the user in the form so that he know what formats are allowed
  validates_attachment_content_type :file, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_presence :file
end

