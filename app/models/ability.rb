class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new Employee if not logged in
    user ||= Employee.new # i.e., a guest user

    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all

    elsif user.role? :manager

      can :manage, Shift
      can :manage, ShiftJob

      # can index store and user
      can :index, Store
      can :index, Employee
      can :index, Assignment
      can :index, Job
      can :show, Job

      #can show store they work for

      can :show, Store do |s|
        s.id == user.current_assignment.store_id
      end

      # they can show assignments at store
      can :show, Assignment do |a|
        a.store == user.current_assignment.store
      end

      # they can read their own profile and users at store
      can :show, Employee do |e|
        e.current_assignment.store == user.current_assignment.store
      end

      # they can update their own profile and users at store
      can :update, Employee do |e|
        e.current_assignment.store_id == user.current_assignment.store_id
      end

      # they can update their own profile and users at store
      can :edit, Employee do |e|
        e.current_assignment.store_id == user.current_assignment.store_id
      end


    elsif user.role? :employee

      can :index, Assignment
      can :manage, Payroll

      # they can read their own data
      can :show, Employee do |this_user|
        user == this_user
      end

      # they can edit their own data
      can :edit, Employee do |this_user|
        user == this_user
      end

      # they can update their own data
      can :update, Employee do |this_user|
        user == this_user
      end

      # they can read their own assignment
      can :show, Assignment do |a|
        user.id == a.employee_id
      end

    else
      # guests can only read home page
    end
  end
end
