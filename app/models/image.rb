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
  has_attached_file :file, styles: { medium: "400x400>", thumb: "100x100>", large: "650x450>" }

  #FIXME_AB: in the form display user a hint which image types you are allowing
  validates_attachment_content_type :file, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_presence :file
end

