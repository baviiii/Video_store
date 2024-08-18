# app/workers/movie_notification_worker.rb
class MovieNotificationWorker
  include Sidekiq::Worker

  def perform
    MovieCopy.includes(:movie_notifications).find_each do |copy|
      next unless copy.in_stock?

      notifications = copy.movie_notifications.where.not(requested_on: nil).where(canceled_on: nil)

      notifications.limit(copy.on_hand).each do |notification|
        next if notification_already_notified?(notification)

        UserMailer.movie_back_in_stock(notification.user, copy.movie).deliver_now
        notification.update(notified_on: Date.current)
      end
    end
  end

  private

  def notification_already_notified?(notification)
    notification.notified_on.present? || notification.user.has_rented?(notification.movie_copy)
  end
end
