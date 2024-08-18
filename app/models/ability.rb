class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin_role == 'super_user'
      can :manage, :all
    elsif user.admin_role == 'admin_user'
      can :manage, [Movie, Actor, Order, MovieCopy]
      can :manage, User, admin_role: 'normal_user' # Admins can manage normal users
      cannot :manage, User, admin_role: 'admin_user' # Admins cannot manage other admins
      cannot :manage, User, admin_role: 'super_user' # Admins cannot manage super users
    elsif user.admin_role == 'normal_user'
      can :read, [Movie, Actor, MovieCopy, Order, MovieNotification]
      can :create, [Order, MovieCopy]
      can :update, [Order, MovieCopy]
      cannot :destroy, [Order, MovieCopy]
      can :read, User, id: user.id # Normal users can read their own user profile
      can :update, Order, user_id: user.id # Normal users can update their own orders
    elsif user.admin_role == 'customer'
      can :read, [Movie, Actor, MovieCopy, Order, MovieNotification]
      can :create, [Order, MovieCopy]
      can :update, [Order, MovieCopy]
      cannot :destroy, [Order, MovieCopy]
      can :read, User, id: user.id # Normal users can read their own user profile
      cannot :access, :admin # Customers cannot access the admin section
    else
      # Guest permissions (not logged in)
      can :read, Movie
    end
  end
end
