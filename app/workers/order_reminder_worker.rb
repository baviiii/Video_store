class OrderReminderWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "OrderReminderWorker started"

    # Retrieve outstanding orders that are overdue
    overdue_orders = Order.where(status: 'rented').where('return_due < ?', Date.today)
    Rails.logger.info "Found #{overdue_orders.count} overdue orders"

    # Iterate over overdue orders
    overdue_orders.each do |order|
      # Calculate the number of days overdue
      days_overdue = (Date.today - order.return_due).to_i
      Rails.logger.info "Order ##{order.id} is #{days_overdue} days overdue"

      # Send reminder email based on the number of days overdue
      case days_overdue
      when 0
        Rails.logger.info "Sending reminder email for order ##{order.id}"
        send_reminder_email(order, 'Reminder: Return Your Videos')
      when 3
        Rails.logger.info "Sending urgent reminder email for order ##{order.id}"
        send_reminder_email(order, 'Urgent Reminder: Return Your Videos')
      else
        Rails.logger.info "Sending overdue reminder email for order ##{order.id}, days overdue: #{days_overdue}"
        send_reminder_email(order, 'Overdue Reminder: Return Your Videos')
      end
    end

    Rails.logger.info "OrderReminderWorker completed"
  end

  private

  # Method to send reminder email
  def send_reminder_email(order, subject)
    # Craft the reminder email content
    body = "Dear #{order.user.first_name},\n\nThis is a reminder that you have an outstanding order that needs to be returned.\n\nPlease return the following videos:\n"

    order.order_movie_copies.each do |order_movie_copy|
      body += "- #{order_movie_copy.movie_copy.movie.title} (Return due: #{order.return_due})\n"
    end

    body += "\nThank you for your attention to this matter.\n\nSincerely,\nThe Video Rental Team"

    # Send the email using Action Mailer
    OrderMailer.order_reminder(order.user.email, subject, body).deliver_now
    Rails.logger.info "Reminder email sent to #{order.user.email} for order ##{order.id}"
  end
end
