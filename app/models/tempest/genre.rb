  ##
  # Genre
class Tempest::Genre < ApplicationRecord
include RailsSortable::Model
set_sortable :sort_order
  acts_as_paranoid
  stampable optional: true

has_many :movie_genres, class_name: 'Tempest::MovieGenre'
has_many :movies, through: :movie_genres

# -- Scope methods start --
scope :query, lambda { |query|
  where("genres.name ILIKE :query", query: "%#{query}%")
}


  ##
  # @!scope class
  # by active status
  # @param active_param (Scope Method) active

  # @return (Scope)
  scope :by_active_status, lambda { |active_param|
     where(active: active_param)
  }

  ##
  # @!scope class
  # by name
  # @param keyword (Scope Method) keyword

  # @return (Scope)
  scope :by_keyword, lambda { |keyword|
     where("name ILIKE ?", "%#{keyword}%")
  }
  # -- Scope methods end --

  # -- Sort methods start --

  ##
  # +SortOption+ Sort Method
  # @!scope class
  # @return (Sort Option)
  sort_option :active, lambda { 
    order( Arel.sql('(genres.active)') )
  }

  ##
  # +SortOption+ Sort Method
  # @!scope class
  # @return (Sort Option)
  sort_option :sort_order, lambda { 
    order( Arel.sql('(genres.sort_order)') )
  }
  # -- Sort methods end --

  humanize :active, boolean: true
  # -- Instance methods start --

  alias_attribute :to_s, :name
  # -- Instance methods end --

  # -- Class methods start --
  # -- Class methods end --

  # FIXME: Update to use a single private def and indent below
  # -- Private methods start --
  # -- Private methods end --
end
