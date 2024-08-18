  ##
  # Movie copy
class Tempest::MovieCopy < ApplicationRecord
  acts_as_paranoid
  stampable optional: true

  
  belongs_to :movie, class_name: '::Movie'

  has_many :movie_notifications, class_name: '::MovieNotification'
  has_many :order_movie_copies, class_name: '::OrderMovieCopy', dependent: :destroy
  has_many :order, through: :order_movie_copies, class_name: '::Order'
  has_many :movie_copies, through: :order_movie_copies, class_name: '::MovieCopy'

 accepts_nested_attributes_for :movie_notifications
 accepts_nested_attributes_for :order_movie_copies
# -- Scope methods start --
scope :query, lambda { |query|
  where("movie_copies.rental_price_currency ILIKE :query", query: "%#{query}%")
}


  ##
  # @!scope class
  # by_keyword_search
  # @param order_titles (Scope Method) order_titles

  # @return (Scope)
  scope :by_keyword_search, lambda { |order_titles|
     where('order_titles LIKE ?', "%#{keyword}%") if keyword.present? 
  }

  ##
  # @!scope class
  # by_status
  # @param status (Scope Method) status

  # @return (Scope)
  scope :by_status, lambda { |status|
    where(status: status) if status.present? 
  }
  # -- Scope methods end --

  # -- Sort methods start --
  # -- Sort methods end --

  humanize :active, boolean: true

after_create :update_on_hand

after_update :update_on_hand_if_necessary
  # -- Instance methods start --

  ##
  # update_on_hand method
  def update_on_hand
     rented_count = Order.joins(:order_movie_copies)
                        .where(order_movie_copies: { movie_copy_id: id })
                        .where(returned: false)
                        .count
    new_on_hand = copies - rented_count
    update_column(:on_hand, new_on_hand)  # Use update_column to avoid recursion in callbacks
    Rails.logger.debug "Updating on_hand for MovieCopy #{id}: rented_count=#{rented_count}, copies=#{copies}, new_on_hand=#{new_on_hand}"
  end

  ##
  # update_on_hand_if_necessary
  def update_on_hand_if_necessary
      def update_on_hand_if_necessary
    update_on_hand if saved_change_to_attribute?(:copies)
  end
  end
  # -- Instance methods end --

  # -- Class methods start --
  # -- Class methods end --
  def to_s
    "#{movie.title} #{stock_type}"
  end

  def in_stock?
    on_hand > 0
  end

  
# FIXME: Update to use a single private def and indent below
  # -- Private methods start --
  # -- Private methods end --
end
