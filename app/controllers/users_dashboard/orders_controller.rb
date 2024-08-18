class UsersDashboard::OrdersController < UsersDashboardController
  before_action :set_order, only: %i[show update destroy]
  before_action :set_order_cart, only: %i[cart add_to_cart remove_from_cart checkout]

  def show
    @related_movies = Movie.where.not(id: @order.movie_copies.pluck(:movie_id)).limit(3)
  end

  def cart
    @order = current_user.orders.find_by(status: 'pending') || Order.new
  end

  def add_to_cart
    movie_copy = MovieCopy.find(params[:movie_copy_id])
    @order = current_user.orders.find_or_create_by(status: 'pending') do |order|
      order.user = current_user
      order.order_date = Date.today
      order.return_due = Date.today + 1.week
    end

    @order.movie_copies << movie_copy unless @order.movie_copies.include?(movie_copy)
    redirect_to cart_users_dashboard_orders_path
  end

  def remove_from_cart
    movie_copy = MovieCopy.find(params[:movie_copy_id])
    @order.movie_copies.delete(movie_copy)
    redirect_to cart_users_dashboard_orders_path, notice: 'Item removed from cart.'
  end

  def checkout
    ActiveRecord::Base.transaction do
      @order.update(status: 'rented', order_date: Date.today, return_due: Date.today + 1.week)
      @order.movie_copies.each(&:update_on_hand)
    end
    # Enqueue job to generate PDF and send email
    OrderReceiptPdfJob.perform_now(@order)
    redirect_to user_dashboard_path, notice: 'Checkout successful!'
  end

  def create
    order_params = params.require(:order).permit(:movie_copy_id, :movie_id)
    movie_copy = MovieCopy.find(order_params[:movie_copy_id])

    order = Order.where(user: current_user, status: 'pending').first_or_initialize do |new_order|
      new_order.user = current_user
      new_order.status = 'pending'
      new_order.returned = false
      new_order.order_date = Date.today
      new_order.return_due = Date.today + 1.week
      new_order.order_titles = "#{movie_copy.movie.title} (#{movie_copy.stock_type.to_s.capitalize})"
    end

    if order.new_record?
      if order.save
        Rails.logger.debug "New order created: #{order.inspect}"
      else
        Rails.logger.debug "New order failed to save: #{order.errors.full_messages}"
      end
    else
      new_order_title = "#{movie_copy.movie.title} (#{movie_copy.stock_type.to_s.capitalize})"
      unless order.order_titles&.include?(new_order_title)
        order.order_titles = [order.order_titles, new_order_title].compact.join(', ')
        order.save
      end
    end

    unless order.movie_copies.include?(movie_copy)
      order.movie_copies << movie_copy
      Rails.logger.debug "Movie copy added to order: #{movie_copy.inspect}"
    end

    redirect_to users_dashboard_order_path(order)
  end

  def update
    movie_copy = MovieCopy.find(params[:movie_copy_id])

    unless @order.movie_copies.include?(movie_copy)
      @order.movie_copies << movie_copy
    end

    redirect_to users_dashboard_order_path(@order)
  end

  def previous_orders
    if user_signed_in?
      @outstanding_orders = current_user.orders.select { |order| order.status == 'rented' }
      @completed_orders = current_user.orders.select { |order| order.status == 'completed' }
    else
      redirect_to new_user_session_path, alert: 'Please sign in to view your orders.'
    end
  end

  def destroy
    @order = current_user.orders.find_by(status: 'pending')
    movie_copy = MovieCopy.find(params[:format])
    @order.movie_copies.delete(movie_copy)
    redirect_to users_dashboard_order_path(@order), notice: 'Movie removed from order.'
  end

  private

  def set_order_cart
    @order = current_user.orders.find_by(status: 'pending')
  end

  def set_order
    @order = current_user.orders.find_by(id: params[:id])
  end
end
