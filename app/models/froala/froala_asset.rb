class Froala::FroalaAsset < ApplicationRecord
  mount_uploader :file, FroalaPictureUploader

  scope :gallery_display, ->{ where(gallery: true) }
end
