class FroalaAssetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include IdReferencing
  skip_authorization_check
  skip_before_action :authenticate_user!, only: %i[get_attachment]

  def upload_attachment
    asset = Froala::FroalaAsset.create(file: params[:file], gallery: true)
    link = get_attachment_froala_asset_url(asset.id)

    respond_to do |format|
      format.json { render json: { status: 'OK', link: } }
    end
  end

  def attachment_gallery
    gallery = []
    Froala::FroalaAsset.gallery_display.each do |asset|
      gallery << {
        url: get_attachment_froala_asset_url(asset.id),
        thumb: get_attachment_froala_asset_url(asset.id, version: :thumb)
      }
    end
    respond_to { |format| format.json { render json: gallery } }
  end

  def destroy
    @froala_asset = Froala::FroalaAsset.find(params[:src].scan(/\d+/).first)
    @froala_asset.destroy
    respond_to { |format| format.json { render json: { status: 'OK' } } }
  end

  def get_attachment
    @froala_asset = Froala::FroalaAsset.find(params[:id])
    content_type =
      view_context.file_config_type(
        @froala_asset.file.content_type&.gsub(%r{.*/}, '')
      )&.to_sym
    version = params[:version]
    if ENV['S3_BUCKET'].present?
      key = if version.present?
              @froala_asset.file.send(version)&.path
            else
              @froala_asset.file&.path
            end

      url = s3_url(key)
    else
      url = @froala_asset.file.url.prepend(CarrierWave.root.to_s)
    end

    response = Net::HTTP.get_response(URI.parse(url))
    send_data response.body, type: content_type, disposition: :inline
  rescue StandardError
    render json: { error: 'Not found', message: 'File does not exist' }, status: 404
  end
end
