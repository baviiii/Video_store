  ##
  # Movie Genre
class Tempest::MovieGenre < ApplicationRecord
  acts_as_paranoid
  stampable optional: true

  
  belongs_to :genre, class_name: '::Genre'
  belongs_to :movie, class_name: '::Movie'
# -- Scope methods start --
  # -- Scope methods end --

  # -- Sort methods start --
  # -- Sort methods end --

  # -- Instance methods start --
  # -- Instance methods end --

  # -- Class methods start --
  # -- Class methods end --

  # FIXME: Update to use a single private def and indent below
  # -- Private methods start --
  # -- Private methods end --
end
