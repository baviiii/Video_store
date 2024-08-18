class UsersDashboardController < ApplicationController
  layout 'public'
    def index
      if user_signed_in?
        rented_movie_ids = current_user.orders.joins(order_movie_copies: :movie_copy).pluck('movie_copies.movie_id')
        @movies = Movie.where.not(id: rented_movie_ids).recent.limit(5)
      else
        @movies = Movie.recent.limit(6)
      end
    rescue StandardError => e
      @movies = []
      logger.error "Failed to load movies: #{e.message}"
    end
  def video_list
    @movies = Movie.all

  end


end
