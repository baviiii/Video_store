##
# Public Access Controller
class PublicController < ActionController::Base
  skip_authorization_check only: :status
  before_action :set_movie, only: [:show]
  layout 'public'

  ##
  # Used for external monitoring
  def status
    commit = `git show --pretty=%H -q`.chomp
    render json: { migration: ActiveRecord::SchemaMigration.last.version,
                   commit: commit,
                   request_ip: request.remote_ip }
  end




  has_scope :by_genre
  has_scope :by_content_rating
  has_scope :above_average_rating, type: :boolean

  respond_to :html, :json, :js
  # users_dashboard/movies_controller.rb
  def index
    @movies = Movie.all
    @genres = Genre.all.order(:name) # Load genres ordered by name
    Rails.logger.debug "Loaded Genres: #{@genres.pluck(:name).join(', ')}"
    @movies = Movie.includes(:genres, :actors).all

    if params[:title].present?
      @movies = @movies.by_keyword(params[:title])
    end

    @movies = @movies.by_genre(params[:by_genre]) if params[:by_genre].present?

    if params[:by_content_rating].present?
      @movies = @movies.by_content_rating(params[:by_content_rating])
    end

    if params[:average_rating].present?
      @movies = @movies.by_average_rating(params[:average_rating].to_f)
    end


    respond_with(@movies) do |format|
      format.html do
        # Set up pagination for the model collection
        @movies = @movies.page(params[:page]).per(@default_limit)

        # clears saved params for filters in redis
        if params[:commit] == 'Clear'
          redirect_to root_path
        elsif request.xhr?
          # for modal display, display just table partial when request made through Javascript
          render partial: 'table'
        end
      end

      # Json return of index
      format.json do
        return nil unless params[:text_output].to_s.include?('select2-code-identifier')

        @movies = User.all.query(params[:query])
        text_output = if params[:text_output].to_s.include?('delete') ||
          params[:text_output].to_s.include?('destroy')
                        'to_s'
                      else
                        params[:text_output].to_s.gsub('select2-code-identifier', '')
                      end
        identifier = text_output.presence || 'to_s'
        @movies = @movies
                    .map { |obj| { 'id': obj.id, 'text': obj&.decorate&.send(identifier) } }
        render json: @movies.compact
      end

      # Javascript handling for index action
      format.js do
        @movies = @movies.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to root_path
        else
          render  'index'
        end
      end
      # -- index_formats_starts --
      # -- index_formats_ends --
    end

  end


  def show
    @related_movies = Movie.where.not(id: @movie.id).limit(3)
  end
  private

  def set_movie
    @movie = Movie.find(params[:id])
  end




end
