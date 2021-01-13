# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    # Grant all privileges to administrators
    can :manage, :all if user.is_admin
  end
end
