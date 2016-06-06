class ImagesCountValidator < ActiveModel::Validator

  def validate(record)
    #FIXME_AB: use reject_if instead of select
    img_len = record.images.reject { |img| img._destroy }.length
    if( img_len < MINIMUM_PUBLISHABLE_IMAGES)
      record.errors[:base] << ("Must  have atleast " + MINIMUM_PUBLISHABLE_IMAGES.to_s + " images to be publishable.")
    end
  end

end
