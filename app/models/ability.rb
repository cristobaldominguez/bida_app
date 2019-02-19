class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all

    elsif user.administrative?
      can :read, [Company, Plant, Alert, Support, Inspection, Logbook, User]
      can :create, [Company, Plant, Alert, Support, Inspection, User]
      can :update, [Logbook, Sampling, SamplingList, Alert, Support, Inspection, User]
      can :destroy, [Logbook, Log, Sampling, SamplingList]

    elsif user.operator?
      can :read, [Plant, Alert, Support, Inspection, Logbook]
      can :update, [Logbook, Sampling, SamplingList]
      can :destroy, [Logbook, Sampling, SamplingList]
      can :create, [Log]

    # elsif user.operations_manager?
    # elsif user.client?
    # elsif user.bf_viewer?
    # elsif user.no_role?

    end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
