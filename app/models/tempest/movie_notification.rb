class Tempest::MovieNotification < ApplicationRecord
  belongs_to :user,  class_name: '::User'
  belongs_to :movie_copy,  class_name: '::MovieCopy'
  # Set a default value for the 'active' attribute
  before_save :set_default_active

  validates :user_id, :movie_copy_id, presence: true
  validates :requested_on, presence: true


  scope :by_title, -> (title) { joins(movie_copy: :movie).where('movies.title ILIKE ?', "%#{title}%") }
  humanize :active, boolean: true
  scope :by_active_selector, -> (active) {
    case active
    when 'true'
      where(active: true)
    when 'false'
      where(active: false)
    else
      all
    end
  }

  # Cancel notifications when needed
  def cancel!
    update(canceled_on: Date.current)
  end

  # Determine if the notification is canceled
  def canceled?
    canceled_on.present?
  end

    private

    def set_default_active
      self.active = true if active.nil?
    end


end
