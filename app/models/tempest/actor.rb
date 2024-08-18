  ##
  # Actor
class Tempest::Actor < ApplicationRecord
  include ClassyEnum::ActiveRecord
  classy_enum_attr :gender, class_name: 'Gender', allow_blank: true,
                                      allow_nil: true

  acts_as_paranoid
  stampable optional: true
  validates_presence_of :first_name

  has_many :movie_actors, class_name: '::MovieActor', dependent: :destroy
  has_many :movies, through: :movie_actors, class_name: '::Movie'

  accepts_nested_attributes_for :movie_actors
  accepts_nested_attributes_for :movies
# -- Scope methods start --
scope :query, lambda { |query|
  where("actors.first_name ILIKE :query
OR actors.last_name ILIKE :query", query: "%#{query}%")
}


  ##
  # @!scope class
  # search
  # @param query (Scope Method) query

  # @return (Scope)
  scope :search, lambda { |query|
     where("first_name LIKE :query OR last_name LIKE :query OR gender LIKE :query", query: "%#{query}%")
 
  }
  # -- Scope methods end --

  # -- Sort methods start --
  # -- Sort methods end --

  # -- Instance methods start --

  ##
  # full_name
  # @param last_name (Instance Method) last_name
# @param first_name (Instance Method) first_name

  def full_name
     "#{first_name} #{last_name}"
  end
  # -- Instance methods end --

  alias_method :to_s, :full_name

  # -- Class methods start --
  # -- Class methods end --

  # FIXME: Update to use a single private def and indent below
  # -- Private methods start --
  # -- Private methods end --
end
