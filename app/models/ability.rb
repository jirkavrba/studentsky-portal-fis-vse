# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Guests have no rights
    return unless user.present?

    # Grant all privileges to administrators
    can :manage, :all if user.is_admin

    # Users can manage their own user profile
    can :manage, User, id: user.id
    # But cannot ban, unban or delete it
    cannot [:ban, :unban, :destroy], User
  end
end
