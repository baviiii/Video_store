  ##
  # order
class Tempest::Order < ApplicationRecord

  include ClassyEnum::ActiveRecord
  classy_enum_attr :status, class_name: 'Status', allow_blank: true,
                   allow_nil: true

  acts_as_paranoid
  stampable optional: true


  has_many :order_movie_copies, class_name: '::OrderMovieCopy', dependent: :destroy
  has_many :movie_copies, through: :order_movie_copies, class_name: '::MovieCopy'
  belongs_to :user, class_name: '::User'

  accepts_nested_attributes_for :movie_copies
  accepts_nested_attributes_for :order_movie_copies
  # -- Scope methods start --
  scope :query, lambda { |query|
    where("orders.order_titles ILIKE :query", query: "%#{query}%")
  }


  ##
  # @!scope class
  # By date 
  # @param order_date (Scope Method) Order date 

  # @return (Scope)
  scope :by_date_from, lambda { |order_date|
    scope :by_date_from, ->(from) { where('order_date >= ?', from) if from.present? }
  }

  ##
  # @!scope class
  # by date
  # @param order_date (Scope Method) order_date

  # @return (Scope)
  scope :by_date_to, lambda { |order_date|
    scope :by_date_to, ->(to) { where('order_date <= ?', to) if to.present? }
  }

  ##
  # @!scope class
  # search by keyword 
  # @param keyword (Scope Method) keyword for title

  # @return (Scope)
  scope :by_keyword_search, lambda { |keyword|
    where('order_titles LIKE ?', "%#{keyword}%") if keyword.present?
  }

  ##
  # @!scope class
  # by status
  # @return (Scope)
  scope :status, lambda {
    scope :by_status, ->(status) { where(status: status) if status.present? }
  }
  # -- Scope methods end --

  # -- Sort methods start --

  ##
  # +SortOption+ By created date 
  # @!scope class
  # @return (Sort Option)
  sort_option :latest_first, lambda {
    scope :latest_first, -> { order(created_at: :desc) }
  }
  # -- Sort methods end --


  before_save :determine_returned
  before_save :order_titles
  humanize :returned, boolean: true
  before_save :update_order_titles
  before_save :update_movie_copy_stock_if_necessary, if: :status_changed?
  after_create :update_movie_copy_stock
  after_destroy :update_movie_copy_stock
  after_save :update_order_titles
  # -- Instance methods start --

  ##
  # determine_returned
  def determine_returned
    self.returned = status == 'completed'
  end

  alias_attribute :to_s, :order_titles

  ##
  # populate_movie_copies
  # @param movie_copy_ids (Instance Method) movie_copy_ids

  def populate_movie_copies(movie_copy_ids)
    movie_copies = MovieCopy.where(id: movie_copy_ids)
    self.movie_copies << movie_copies
    update_order_titles
  end


  ##
  # Update the stock of the movie copy 
  def update_movie_copy_stock
    movie_copies.each do |movie_copy|
      movie_copy.update_on_hand
    end
  end

    ##
    # update movie copy if needed (double verification)
    def update_movie_copy_stock_if_necessary
      Rails.logger.debug "Updating stock after order completed: #{id}"
      update_movie_copy_stock
    end

    ##
    # update_order_titles
    def update_order_titles
      self.order_titles = movie_copies.map { |copy| "#{copy.movie.title} - #{copy.stock_type.to_s.capitalize}" }.join(', ')

    end

  def mark_as_returned
    self.returned = true
    self.status =  'completed'
    self.returned_on = Date.today
    save
  end

    # -- Instance methods end --

    # -- Class methods start --
    # -- Class methods end --

    # FIXME: Update to use a single private def and indent below
    # -- Private methods start --
    # -- Private methods end --

end