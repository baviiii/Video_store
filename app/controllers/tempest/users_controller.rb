class Tempest::UsersController < AdminController
  has_scope :in_order, as: :sort, allow_blank: true, default: 'name_sort'
  has_scope :reverse_order, type: :boolean
  load_and_authorize_resource
  respond_to :html
  has_scope :query

  decorates_assigned :users, :user

  # filter_scopes_start_here
has_scope :search, only: [:index]

has_scope :active_selector, only: [:index]

  # filter_scopes_end_here

  def index
    index_setup
    @title = 'names' unless @title
  
    @users = apply_scopes(@users)
    respond_with(@users) do |format|

      # index html group content starts here
      # index html group content ends here

      format.html do
        @users = @users.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([:users])
        else
          render partial: 'table' if request.xhr?
        end
      end
      format.json do
        return nil unless params[:text_output].to_s.include?('select2-code-identifier')
        @users = User.all.query(params[:query])
        text_output = (params[:text_output].to_s.include?('delete') ||
          params[:text_output].to_s.include?('destroy')) ?
                        'to_s' : params[:text_output].to_s.gsub('select2-code-identifier', '')
        identifier = text_output.presence || 'to_s'
        @users = @users.
          map { |obj| { 'id': obj.id, 'text': obj&.decorate&.send(identifier) } }
        render json: @users.compact
      end
      format.js do
        @users = @users.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([:users])
        else
          render 'index'
        end
      end
      # -- index_formats_starts --
      # -- index_formats_ends --
    end
  end

  def show
    @title = @user
    
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
    
    @title = 'New name'
    if request.xhr?
      render partial: 'quick_edit_form'
    end
    
  end

  def create
    @title = "Edit #{@user}"
  
  
    respond_to do |format|
        @user.skip_password_validation = true
if @user.save
    @user.invite!(current_user)
        format.html do
          if request.xhr?
            row_partial = user_params[:alt_list].present? ? user_params[:alt_list] : 'user'
            render partial: row_partial, locals: { "#{row_partial}": @user }, status: 200
          else
           
           redirect_to edit_admin_user_path(@user)
           
          end
        end
        format.json do
          render json: { 'record_id': @user&.id }
        end
      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = 'New User'
            render action: :new
          end
        end

        format.json do
          render json: { 'record_id': @user&.id }
        end

      end
    end
  
  end

  def edit
  
    @title = "Edit #{@user}"
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
    @title = "Edit #{@user}"
  
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          if request.xhr?
            row_partial = user_params[:alt_list].present? ? user_params[:alt_list] : 'user'
            render partial: row_partial, locals: { "#{row_partial}": @user }, status: 200
          else
           
           redirect_to edit_admin_user_path(@user), notice: 'User was successfully updated.'
           
          end
        end

        format.json do
          render json: { 'record_id': @user&.id }
        end

      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = "Edit #{@user}"
            render action: :edit
          end
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  
  end

  def destroy
              destroy_common(@user, admin_users_path)

  end

  # -- custom_actions_starts --
  # -- custom_actions_ends --

    ##
  # reset password action
def reset_password
  @user.reset_login_password
    redirect_to user_path(@user), notice: "Password for user has been reset"
  
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


  index_store_name = "bavindu_video_blast_users_index_#{current_user.id}"


  ## nested model setup starts ##
  ## nested model setup ends ##


  # fetch_store(index_store_name, ['search_by'])

end


    def user_params
      full_attributes = [
:active, 
:address_line_1, 
:address_line_2, 
:admin, 
:admin_role, 
:email, 
:first_name, 
:gender, 
:last_name, 
{ movie_notification_ids: [] }, 
{ order_ids: [] }, 
:postcode, 
:state, 
:suburb, 
{ user_rating_ids: [] }, 
{ user_ids: [] }, 
:alt_list]

      params.require(:user)
            .permit(*strong_accessible_params(@user,
                                              User,
                                              full_attributes))
    end

    # -- private_actions_starts --
    # -- private_actions_ends --
end
