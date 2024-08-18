##
# Controller for the Private AWS Image Covers
class Tempest::CoversController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
    return unless authorize!(:view_cover, @movie)

    image_type = params[:type]
    @image = @movie.cover
    data = URI.open(@image.url(image_type&.to_sym))
    send_data data.read
  end
end
