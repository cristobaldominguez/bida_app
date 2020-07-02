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

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.operations_manager?
      can :manage, [Alert, Support, Inspection, Logbook, Log, Sampling, SamplingList, Report, Plant, GraphStandard, FlowReport, Flow]
      can %i[read create update], User
    elsif user.operator?
      can :read, Plant
      can :logbook, Plant
      can %i[read update], [Logbook, Log]
      can %i[read update], User, id: user.id
    elsif user.client?
      can %i[read update], Logbook
      can :read, [Report, Alert, Support, Inspection, Plant]
    elsif user.viewer?
      can :read, :all
    end
  end
end
