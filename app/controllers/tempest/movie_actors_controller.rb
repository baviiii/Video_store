class Tempest::MovieActorsController < AdminController
  has_scope :in_order, as: :sort, allow_blank: true, default: 'sort_order'
  has_scope :reverse_order, type: :boolean
  load_and_authorize_resource :actor

  load_and_authorize_resource :movie
  load_and_authorize_resource through: %i[movie actor], shallow: true


  load_and_authorize_resource only: :actor_movies
  respond_to :html
  has_scope :query

  decorates_assigned :movie_actors, :movie_actor

  # filter_scopes_start_here
  # filter_scopes_end_here

  def index
    @title = 'Cast' if @movie
    index_setup
    @title ||= 'Movie Actors'

    @movie_actors = apply_scopes(@movie_actors)
    respond_with(@movie_actors) do |format|
      # index html group content starts here
      # index html group content ends here

      format.html do
        @movie_actors = @movie_actors.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([@movie || @actor, :movie_actors])
        elsif request.xhr?
          render partial: 'table'
        end
      end
      format.json do
        return nil unless params[:text_output].to_s.include?('select2-code-identifier')

        @movie_actors = MovieActor.all.query(params[:query])
        text_output = if params[:text_output].to_s.include?('delete') ||
                         params[:text_output].to_s.include?('destroy')
                        'to_s'
                      else
                        params[:text_output].to_s.gsub('select2-code-identifier', '')
                      end
        identifier = text_output.presence || 'to_s'
        @movie_actors = @movie_actors
                        .map { |obj| { 'id': obj.id, 'text': obj&.decorate&.send(identifier) } }
        render json: @movie_actors.compact
      end
      format.js do
        @movie_actors = @movie_actors.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([@movie || @actor, :movie_actors])
        else
          render 'index'
        end
      end
      # -- index_formats_starts --
      # -- index_formats_ends --
    end
  end

  def show
    @title = @movie_actor

    return unless request.xhr?

    if params[:single_show_edit]
      render partial: 'show'
    else
      render partial: 'modal_show'
    end
  end

  def new
    @alt_list = params[:alt_list]

    @title = 'New Movie Actor'
    return unless request.xhr?

    render partial: 'quick_edit_form'
  end

  def create
    @title = "Edit #{@movie_actor}"

    logger.debug "Order Params: #{movie_actor_params.inspect}"
    logger.debug "Order Errors: #{@movie_actor.errors.full_messages}" unless @movie_actor.valid?
    @movie = Movie.find(params[:movie_actor][:movie_id])
    actor_ids = params[:movie_actor][:actor_id].reject(&:blank?)

    actor_ids.each do |actor_id|
      @movie_actor = MovieActor.new(movie_id: @movie.id, actor_id: actor_id)
      unless @movie_actor.save
        respond_to do |format|
          format.html do
            if request.xhr?
              render partial: 'quick_edit_form', status: 422
            else
              @title = 'New Movie Actor'
              render action: :new
            end
          end
          format.json { render json: { 'record_id': @movie_actor&.id } }
        end
        return # Exit the action if any save fails
      end
    end

    respond_to do |format|
      if @movie_actor.save
        format.html do
          if request.xhr?
            row_partial = movie_actor_params[:alt_list].present? ? movie_actor_params[:alt_list] : 'movie_actor'
            render partial: row_partial, locals: { "#{row_partial}": @movie_actor }, status: 200
          else
            redirect_to edit_admin_movie_actor_path(@movie_actor)
          end
        end
        format.json { render json: { 'record_id': @movie_actor&.id } }
      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = 'New Movie Actor'
            render action: :new
          end
        end
        format.json { render json: { 'record_id': @movie_actor&.id } }
      end
    end
  end




  def edit
    @title = "Edit #{@movie_actor}"
    @alt_list = params[:alt_list]
    return unless request.xhr?

    if params[:single_show_edit]
      render partial: 'form'
    else
      render partial: 'quick_edit_form'
    end
  end

  def update
    @title = "Edit #{@movie_actor}"

    respond_to do |format|
      if @movie_actor.update(movie_actor_params)
        format.html do
          if request.xhr?
            row_partial = movie_actor_params[:alt_list].present? ? movie_actor_params[:alt_list] : 'movie_actor'
            render partial: row_partial, locals: { "#{row_partial}": @movie_actor }, status: 200
          else

            redirect_to edit_admin_movie_actor_path(@movie_actor), notice: 'Movie Actor was successfully updated.'

          end
        end

        format.json do
          render json: { 'record_id': @movie_actor&.id }
        end

      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = "Edit #{@movie_actor}"
            render action: :edit
          end
        end
        format.json { render json: @movie_actor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    destroy_common(@movie_actor, admin_movie_actors_path)
  end

  # -- custom_actions_starts --
  # -- custom_actions_ends --

  ##
  # actor movies
  def actor_movies
    @title = 'Actor Movies'

    @movie_actors = apply_scopes(@movie_actors.includes(:movie))
    index_setup

    @allow_create = true
    @full_edit_create = false
    @default_limit = 25
    @pdf_button = false
    @copy_button = false
    @csv_button = false
    @xls_button = false
    @print_button = false

    respond_with(@movie_actors) do |format|
      # actor_movies html group content starts here
      # actor_movies html group content ends here

      format.html do
        @movie_actors = @movie_actors.page(params[:page]).per(@default_limit)

        if params[:commit] == 'Clear'
          redirect_to polymorphic_path(%i[actor_movies movie_actors])
        elsif request.xhr?
          render partial: 'actor_movies_table'
        end
      end
      format.js do
        @movie_actors = @movie_actors.page(params[:page]).per(@default_limit)
        @table_name = 'actor_movies_table'
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([@movie || @actor, :actor_movies, :movie_actors])
        else
          render 'index'
        end
      end
    end
  end

  private

  def index_setup
    @allow_create = true
    @full_edit_create = false
    @default_limit = 25
    @allow_filter = false
    @pdf_button = false
    @copy_button = false
    @csv_button = false
    @xls_button = false
    @print_button = false
    @main_list_screen = true
    @icon = ''
    @show_buttons = @pdf_button || @copy_button || @csv_button || @xls_button || @print_button



    ## nested model setup starts ##
    if @actor
      @allow_create = true
      @full_edit_create = false
      @default_limit = 25
      @allow_filter = true
      @pdf_button = false
      @copy_button = false
      @csv_button = false
      @xls_button = false
      @print_button = false
      @icon = ''



    end
    return unless @movie

    @allow_create = true
    @full_edit_create = false
    @default_limit = 25
    @allow_filter = true
    @pdf_button = false
    @copy_button = false
    @csv_button = false
    @xls_button = false
    @print_button = false
    @icon = ''




    ## nested model setup ends ##
  end

  def movie_actor_params
    full_attributes = [
      { actor_ids: [] },
      :movie_id,
      { movie_ids: [] },
      :sort_order,
      :alt_list,
      :actor_id
    ]

    params.require(:movie_actor)
          .permit(*strong_accessible_params(@movie_actor,
                                            MovieActor,
                                            full_attributes))
  end
  private

  # -- private_actions_starts --
  # -- private_actions_ends --
end
