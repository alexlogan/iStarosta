class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new # guest user (not logged in)

      can :read, :all
      cannot :read, MedicalCertificate

      if user.admin?
        can :access, :rails_admin  
        can :dashboard
        can :manage, :all
      elsif user.group.present?
        can :manage, Group, :id => user.group.id
        can :manage, Lesson, :group => { :id => user.group.id }
        can :manage, Student, :group => { :id => user.group.id }
        can :manage, Log, :lesson => { :group_id => user.group.id }
        can :manage, MedicalCertificate, :student => { :group_id => user.group.id }
        cannot :import, [Log, Lesson]
      end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
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
