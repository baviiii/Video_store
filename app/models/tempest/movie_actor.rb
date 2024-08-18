  ##
  # Movies actors
class Tempest::MovieActor < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort_order
    acts_as_paranoid
    stampable optional: true

  belongs_to :actor, class_name: '::Actor'
  belongs_to :movie, class_name: '::Movie'
# -- Scope methods start --
  # -- Scope methods end --

  # -- Sort methods start --

  ##
  # +SortOption+ Sort Method
  # @!scope class
  # @return (Sort Option)
  sort_option :sort_order, lambda { 
    order( Arel.sql('(movie_actors.sort_order)') )
  }
  # -- Sort methods end --

  # -- Instance methods start --

  ##
  # full name
  def full_name
    actor&.first_name.to_s + ' ' + actor&.last_name.to_s
  end

  ##
  # released year 
  def year
    movie.year
  end
  # -- Instance methods end --

  alias_method :to_s, :full_name

  # -- Class methods start --
  # -- Class methods end --

  # FIXME: Update to use a single private def and indent below
  # -- Private methods start --
  # -- Private methods end --
end
