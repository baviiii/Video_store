class Tempest::OrdersController < AdminController
    has_scope :reverse_order, type: :boolean
    load_and_authorize_resource :user
  load_and_authorize_resource through: [:user], shallow: true


  load_and_authorize_resource only: :outstanding_orders
respond_to :html
  has_scope :query

  decorates_assigned :orders, :order

  # filter_scopes_start_here
has_scope :status, only: [:outstanding_orders, :index]

has_scope :by_date_from, only: [:outstanding_orders, :index]

has_scope :by_date_to, only: [:outstanding_orders, :index]

has_scope :by_keyword_search, only: [:index]

  # filter_scopes_end_here

  def index
    index_setup
    @title = 'Orders' unless @title
  
    @orders = apply_scopes(@orders)
    respond_with(@orders) do |format|

      # index html group content starts here
      # index html group content ends here

      format.html do
        @orders = @orders.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([(@user), :orders])
        else
          render partial: 'table' if request.xhr?
        end
      end
      format.json do
        return nil unless params[:text_output].to_s.include?('select2-code-identifier')
        @orders = Order.all.query(params[:query])
        text_output = (params[:text_output].to_s.include?('delete') ||
          params[:text_output].to_s.include?('destroy')) ?
                        'to_s' : params[:text_output].to_s.gsub('select2-code-identifier', '')
        identifier = text_output.presence || 'to_s'
        @orders = @orders.
          map { |obj| { 'id': obj.id, 'text': obj&.decorate&.send(identifier) } }
        render json: @orders.compact
      end
      format.js do
        @orders = @orders.page(params[:page]).per(@default_limit)
        if params[:commit] == 'Clear'
          redirect_to polymorphic_path([(@user), :orders])
        else
          render 'index'
        end
      end
      # -- index_formats_starts --
      # -- index_formats_ends --
    end
  end

  def show
    @title = @order
    
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
    
    @title = 'New Order'
    if request.xhr?
      render partial: 'quick_edit_form'
    end
    
  end

  def create
    @title = "Edit #{@order}"
    # movie_copy_ids = params[:order][:movie_copy_ids].reject(&:empty?)
    # @order.populate_movie_copies(movie_copy_ids)
    logger.debug "Order Params: #{order_params.inspect}"
    logger.debug "Order Errors: #{@order.errors.full_messages}" unless @order.valid?

    respond_to do |format|
      if @order.save
        OrderReceiptPdfJob.perform_now(@order)
        format.html do
          if request.xhr?
            row_partial = order_params[:alt_list].present? ? order_params[:alt_list] : 'order'
            render partial: row_partial, locals: { "#{row_partial}": @order }, status: 200
          else
            # Enqueue job to generate PDF and send email
           redirect_to edit_admin_order_path(@order)
           
          end
        end
        format.json do
          render json: { 'record_id': @order&.id }
        end
      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = 'New Order'
            render action: :new
          end
        end

        format.json do
          render json: { 'record_id': @order&.id }
        end

      end
    end
  
  end

  def edit
  
    @title = "Edit #{@order}"
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
    @title = "Edit #{@order}"
  
    respond_to do |format|
      if @order.update(order_params)
        format.html do
          if request.xhr?
            row_partial = order_params[:alt_list].present? ? order_params[:alt_list] : 'order'
            render partial: row_partial, locals: { "#{row_partial}": @order }, status: 200
          else
           
           redirect_to edit_admin_order_path(@order), notice: 'Order was successfully updated.'
           
          end
        end

        format.json do
          render json: { 'record_id': @order&.id }
        end

      else
        format.html do
          if request.xhr?
            render partial: 'quick_edit_form', status: 422
          else
            @title = "Edit #{@order}"
            render action: :edit
          end
        end
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  
  end

  def destroy
              destroy_common(@order, admin_orders_path)

  end

  # -- custom_actions_starts --
  # -- custom_actions_ends --

    ##
  #  outstanding orders.
def outstanding_orders

  # outstanding_orders_store_name = "bavindu_video_blast_orders_outstanding_orders_" +
  #   current_user.to_s.parameterize.underscore
  # fetch_store(outstanding_orders_store_name, ['search_by'])

@title = 'Outstanding Orders'

@orders = apply_scopes(@orders)
index_setup

@allow_create = true
@full_edit_create = false
@default_limit = 25
@pdf_button = false
@copy_button = false
@csv_button = false
@xls_button = false
@print_button = false

respond_with(@orders) do |format|

  # outstanding_orders html group content starts here
  # outstanding_orders html group content ends here

  format.html do
    @orders = @orders.page(params[:page]).per(@default_limit)

    if params[:commit] == 'Clear'
      redirect_to polymorphic_path(%i[outstanding_orders orders])
    elsif request.xhr?
      render partial: 'outstanding_orders_table'
    end
  end
  format.js do
    @orders = @orders.page(params[:page]).per(@default_limit)
    @table_name = 'outstanding_orders_table'
    if params[:commit] == 'Clear'
      redirect_to polymorphic_path([(@user), :outstanding_orders, :orders])
    else
      render 'index'
    end
  end
end

  
  
end
  ##
  # Generated action for action button
def returned
    if @order.respond_to?(:returned, true)
      method_return = @order.send(:mark_as_returned)
      if method_return.is_a?(Hash)
        result = { type: method_return[:status].to_s == 'true' ? 'success' : 'error',
                   message: method_return[:message].to_s }
      elsif [true, false].include? method_return
        if method_return
          result = { type: 'success', message: 'Action has been performed successfully' }
        else
          result = { type: 'error', message: 'Cannot execute the method' }
        end
      else
        result = { type: 'success',
                   message: "Action has been performed successfully. The result is #{
      method_return.to_s }" }
      end
      else
        result = { type: 'error', message: 'Method cannot be found' }
      end
      render json: result
   
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


  index_store_name = "bavindu_video_blast_orders_index_#{current_user.id}"


  ## nested model setup starts ##
if @user
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



index_store_name = "bavindu_video_blast_user_#{@user.id}_orders_index_#{current_user.id}"

end
  ## nested model setup ends ##


  # fetch_store(index_store_name, ['search_by'])

end


    def order_params
      full_attributes = [
{ movie_copy_ids: [] }, 
:order_date, 
{ order_movie_copy_ids: [] }, 
:order_titles, 
:return_due, 
:returned, 
:returned_on, 
:status, 
:user_id, 
:alt_list]

      params.require(:order)
            .permit(*strong_accessible_params(@order,
                                              Order,
                                              full_attributes))
    end

    # -- private_actions_starts --
    # -- private_actions_ends --
end
