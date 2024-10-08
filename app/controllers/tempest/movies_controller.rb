class Tempest::MoviesController < AdminController
    has_scope :reverse_order, type: :boolean
  load_and_authorize_resource
  respond_to :html
  has_scope :query

  decorates_assigned :movies, :movie

  # filter_scopes_start_here
has_scope :active_selector, only: [:index]

has_scope :by_keyword, only: [:index]

  # filter_scopes_end_here

  def index
    index_setup
    @title = 'Movies' unless @title
  
    @movies = apply_scopes(@movies)
    respond_with(@movies) do |format|

      # index html group content starts here
      # index html group content ends here

      format.html do
        @movies = @movies.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([:movies])
        else
          render partial: 'table' if request.xhr?
        end
      end
      format.json do
        return nil unless params[:text_output].to_s.include?('select2-code-identifier')
        @movies = Movie.all.query(params[:query])
        text_output = (params[:text_output].to_s.include?('delete') ||
          params[:text_output].to_s.include?('destroy')) ?
                        'to_s' : params[:text_output].to_s.gsub('select2-code-identifier', '')
        identifier = text_output.presence || 'to_s'
        @movies = @movies.
          map { |obj| { 'id': obj.id, 'text': obj&.decorate&.send(identifier) } }
        render json: @movies.compact
      end
      format.js do
        @movies = @movies.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([:movies])
        else
          render 'index'
        end
      end
      # -- index_formats_starts --
      # -- index_formats_ends --
    end
  end

  def show
    @title = @movie
    
    if request.xhr?
      if params[:single_show_edit]
        render partial: 'show'
      else
        render partial: 'modal_show'
      end
    
    end
  end

  def new
    @alt_list = params[:alt_list]
    
    @title = 'New Movie'
    if request.xhr?
      render partial: 'quick_edit_form'
    end
    
  end

  def create
    @title = "Edit #{@movie}"
  
  
    respond_to do |format|
      if @movie.save
        format.html do
          if request.xhr?
            row_partial = movie_params[:alt_list].present? ? movie_params[:alt_list] : 'movie'
            render partial: row_partial, locals: { "#{row_partial}": @movie }, status: 200
          else
           
           redirect_to edit_admin_movie_path(@movie)
           
          end
        end
        format.json do
          render json: { 'record_id': @movie&.id }
        end
      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = 'New Movie'
            render action: :new
          end
        end

        format.json do
          render json: { 'record_id': @movie&.id }
        end

      end
    end
  
  end

  def edit
  
    @title = "Edit #{@movie}"
    @alt_list = params[:alt_list]
  if request.xhr?
      if params[:single_show_edit]
        render partial: 'form'
      else
        render partial: 'quick_edit_form'
      end
    end
  
  end

  def update
    @title = "Edit #{@movie}"
  
    respond_to do |format|
      if @movie.update(movie_params)
        format.html do
          if request.xhr?
            row_partial = movie_params[:alt_list].present? ? movie_params[:alt_list] : 'movie'
            render partial: row_partial, locals: { "#{row_partial}": @movie }, status: 200
          else
           
           redirect_to edit_admin_movie_path(@movie), notice: 'Movie was successfully updated.'
           
          end
        end

        format.json do
          render json: { 'record_id': @movie&.id }
        end

      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = "Edit #{@movie}"
            render action: :edit
          end
        end
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  
  end

  def destroy
              destroy_common(@movie, admin_movies_path)

  end

  # -- custom_actions_starts --
  # -- custom_actions_ends --

    ##
  # actor movies
def actor_movies
  
  
end
  ##
  # Action for cover Uploads to handle private requests
def private_cover
  
                  return nil unless @movie.cover.present?
                  begin
                    content_type = view_context.file_config_type(@movie.
                                      file.content_type&.gsub(/.*\//, ''))&.to_sym
                    version = params[:version]
                    if ENV['S3_BUCKET'].present?
                      if version.present?
                        key = @movie.cover.send(version)&.path
                      else
                        key = @movie.cover&.path
                      end
                      url = s3_url(key)
                    else
                      url = @movie.cover.url.prepend(CarrierWave.root.to_s)
                    end
                    data = open(url)
                    send_data data&.read, type: content_type, disposition: :inline
                  rescue
                    send_file 'public/not_found.jpg', type: 'image/jpeg', disposition: :inline
                  end
                  ensure
                  data&.close rescue nil
  
end
private
def index_setup
  @allow_create = true
  @full_edit_create = false
  @default_limit = 25
  @allow_filter = true
  @pdf_button = false
  @copy_button = false
  @csv_button = false
  @xls_button = false
  @print_button = false
  @main_list_screen = true
  @icon = ''
  @show_buttons = @pdf_button || @copy_button || @csv_button || @xls_button || @print_button


  index_store_name = "bavindu_video_blast_movies_index_#{current_user.id}"


  ## nested model setup starts ##
  ## nested model setup ends ##


  # fetch_store(index_store_name, ['by_keyword'])

end


    def movie_params
      full_attributes = [
:active, 
{ actor_ids: [] }, 
:content_rating, 
:cover, 
:remove_cover, 
:description, 
{ genre_ids: [] }, 
{ movie_actor_ids: [] }, 
{ movie_copy_ids: [] }, 
{ movie_genre_ids: [] }, 
:released_on, 
:remove_cover, 
:title, 
{ user_rating_ids: [] }, 
:alt_list]

      params.require(:movie)
            .permit(*strong_accessible_params(@movie,
                                              Movie,
                                              full_attributes))
    end

    # -- private_actions_starts --
    # -- private_actions_ends --
end
