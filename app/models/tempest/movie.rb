  ##
  # Movie screen
class Tempest::Movie < ApplicationRecord
  acts_as_paranoid
  stampable optional: true


  # Association with movie_actors join table
  has_many :movie_actors, class_name: '::MovieActor', dependent: :destroy
  has_many :actors, through: :movie_actors, class_name: '::Actor'

  has_many :movie_genres, class_name: '::MovieGenre'

  has_many :genres, class_name: '::Genre', through: :movie_genres

  has_many :movie_copies, class_name: '::MovieCopy', dependent: :destroy

  has_many :user_ratings, class_name: '::UserRating', dependent: :restrict_with_error


 accepts_nested_attributes_for :actors
 accepts_nested_attributes_for :genres
 accepts_nested_attributes_for :movie_actors
 accepts_nested_attributes_for :movie_copies
 accepts_nested_attributes_for :movie_genres
 accepts_nested_attributes_for :user_ratings
# -- Scope methods start --
scope :query, lambda { |query|
  where("movies.title ILIKE :query", query: "%#{query}%")
}


  ##
  # @!scope class
  # by active status
  # @param active_param (Scope Method) active status

  # @return (Scope)
  scope :active_selector, lambda { |active_param|
     where(active: active_param)
  }

  ##
  # @!scope class
  # By movie name or description
  # @param keyword (Scope Method) keyword
  scope :by_content_rating, ->(rating) { where(content_rating: rating) }
  # @return (Scope)
  scope :by_keyword, lambda { |keyword|
     where('title ILIKE :search OR description ILIKE :search', search: "%#{keyword}%") 
  }
  # -- Scope methods end --

  # -- Sort methods start --
  # -- Sort methods end --

  humanize :active, boolean: true
    mount_uploader :cover, ImageUploader
  humanize :remove_cover, boolean: true
  # -- Instance methods start --

  alias_attribute :to_s, :title

  ##
  # Year Movie was released
  # @param released_on (Date) released_on

  def year
    released_on.year
  end
  def self.by_average_rating(min_rating)
    select('movies.*, COALESCE(AVG(user_ratings.rating), 0) AS average_rating')
      .joins(:user_ratings)
      .group('movies.id')
      .having('COALESCE(AVG(user_ratings.rating), 0) >= ?', min_rating)
  end

  def average_rating
    user_ratings.average(:rating).to_f.round(2) || 0
  end

  # -- Instance methods end --

  # -- Class methods start --
  # -- Class methods end --

  # FIXME: Update to use a single private def and indent below
  # -- Private methods start --
  # -- Private methods end --
end
