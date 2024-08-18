##
# ImageUploader Image Uploader - Movie cover
class ImageUploader < BaseUploader

  include CarrierWave::MiniMagick

  def extension_whitelist
    %w(jpg)
  end

# -- Uploader methods start --
                      version :JPEG, if: :is_picture? do
                        process :resize_to_fit => [25, 25]
                      end
# -- Uploader methods end --

  version :thumb, if: :is_picture? do
    process resize_to_fill: [100, 100]
  end
end
