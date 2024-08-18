# app/controllers/users_dashboard/movie_notifications_controller.rb
module UsersDashboard
  class MovieNotificationsController < ApplicationController
    before_action :authenticate_user!
    layout "public"


    respond_to :html, :json
    has_scope :query

    def index

      @movie_notifications = current_user.movie_notifications.where(canceled_on: nil)
    end
    def create
      @movie_notification = MovieNotification.new(movie_notification_params)
      @movie_notification.user = current_user

      if @movie_notification.save
        render json: { success: true, message: 'Notification request created successfully' }
      else
        render json: { success: false, message: 'Error creating notification request' }
      end
    end
    def destroy
      @movie_notification = current_user.movie_notifications.find(params[:id])
      if @movie_notification.update(canceled_on: Date.current)
        flash[:success] = 'Notification successfully removed from your waitlist.'
        respond_to do |format|
          format.json { render json: { success: true } }
        end
      else
        flash[:error] = 'Unable to remove the notification from your waitlist.'
        respond_to do |format|
          format.json { render json: { success: false, error: @movie_notification.errors.full_messages } }
        end
      end
    end


    def edit
      @notifications = @user.movie_notifications
    end

    private

    def notification_params
      params.require(:movie_notification).permit(:movie_copy_id)
    end
  end
end
