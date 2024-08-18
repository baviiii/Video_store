class Admin::DashboardController < AdminController
  before_action :set_dashboard, only: [:show, :edit, :destroy] # Removed :update
  def index
    redirect_to admin_users_path
  end
end
