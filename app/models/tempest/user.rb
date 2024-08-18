  ##
  # user list
class Tempest::User < ApplicationRecord
  include ClassyEnum::ActiveRecord
  classy_enum_attr :gender, class_name: 'Gender', allow_blank: true,
                                      allow_nil: true

  model_stamper
  acts_as_paranoid
  stampable optional: true
  attr_accessor :skip_password_validation
  after_save :set_admin_attribute
  has_many :movie_notifications, class_name: '::MovieNotification', dependent: :restrict_with_error

  has_many :orders, class_name: '::Order', dependent: :destroy

  has_many :user_ratings, class_name: '::UserRating', dependent: :restrict_with_error

  has_many :users, class_name: '::MovieNotification'
 accepts_nested_attributes_for :movie_notifications
 accepts_nested_attributes_for :orders
 accepts_nested_attributes_for :user_ratings
 accepts_nested_attributes_for :users
# -- Scope methods start --
scope :query, lambda { |query|
  where("users.address_line_1 ILIKE :query
OR users.address_line_2 ILIKE :query
OR users.first_name ILIKE :query
OR users.last_name ILIKE :query
OR users.state ILIKE :query
OR users.suburb ILIKE :query", query: "%#{query}%")
}


  ##
  # @!scope class
  # sort by active or not
  # @param active_param (Scope Method) user active status

  # @return (Scope)
  scope :active_selector, lambda { |active_param|
     where(active: active_param)
  }

  ##
  # @!scope class
  # search by name or email
  # @param email (Scope Method) user email
# @param last_name (Scope Method) user last name
# @param first_name (Scope Method) user  fist name

  # @return (Scope)
  scope :search, lambda { |query|
     where('first_name ILIKE :query OR last_name ILIKE :query OR email ILIKE :query', query: "%#{query}%")

  
  }
  # -- Scope methods end --

  # -- Sort methods start --

  ##
  # +SortOption+ Create a name sort method which orders by Last Name then First name ignoring case e.g. UPPER()
   # 
  # # Set this method as the default sort on the user model.
  # @!scope class
  # @param first_name (Scope Method) first_name
# @param last_name (Scope Method) last_name

  # @return (Sort Option)
  sort_option :name_sort, lambda {
     order("LOWER(last_name), LOWER(first_name)") 
  }
  # -- Sort methods end --

  humanize :active, boolean: true
  humanize :admin, boolean: true
  # -- Instance methods start --

  ##
  # Create a Name method that combines First Name and Last name, and set this as the display identifier for the model.
  # @return (String)
  def name
     "#{first_name} #{last_name}"
  end


  def set_admin_attribute
    if admin_role == 'super_user' || admin_role == 'admin_user' || admin_role == 'normal_user'
      self.update_column(:admin, true)
      Rails.logger.debug "Setting admin to true"  # Debug output
    else
      self.update_column(:admin, false)
      Rails.logger.debug "Setting admin to false"  # Debug output
    end
  end

  def has_rented?(movie_copy)
    orders.where(movie_copy_id: movie_copy.id).exists?
  end
  ##
# To initialize tokens for letter template content
def to_liquid
  UserMergeField.new(self)
end
# -- Instance methods end --

  alias_method :to_s, :name

  # -- Class methods start --
  # -- Class methods end --

  # FIXME: Update to use a single private def and indent below
  # -- Private methods start --
  # -- Private methods end --
end
class UserMergeField < Liquid::Drop
  def initialize(user)
    @user = user
    @user = (user.respond_to?(:recipient) && user.recipient.present?) ? user.recipient : user&.user
    if user.trigger_record_id.present?
      class_name = user.trigger_record_class.present? ? user.trigger_record_class : user.comm_trigger.anchor_model
      instance_variable_set('@' + class_name.underscore.parameterize, class_name.constantize.find(user.trigger_record_id))
    end
  end

  # -- Liquid methods start --
private def password_reset_url_description
  'liquid token for reset password url'
end
def password_reset_url
  Rails.application.routes.url_helpers.edit_person_password_url(reset_password_token:
                                 @User.send(:set_reset_password_token))
end
private def signup_confirmation_url_description
  'liquid token for password confirmation'
end
def signup_confirmation_url
  Rails.application.routes.url_helpers.person_confirmation_url(confirmation_token:
                                 @User.send(:generate_confirmation_token))
end
  # -- Liquid methods end --



end
