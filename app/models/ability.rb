class Ability
  include CanCan::Ability

  def initialize(employee)
    # set employee to new Employee if not logged in
    employee ||= Employee.new # i.e., a guest employee

    # set authorizations for different employee roles
    if employee.role? :admin
      # they get to do it all
      can :manage, :all

    elsif employee.role? :manager

      can :manage, Shift
      can :manage, ShiftJob

      # can index store and employee
      can :index, Store
      can :index, Employee
      can :index, Assignment

      #can show store they work for

      can :show, Store do |s|
        s.id == employee.current_assignment.store_id
      end

      # they can show assignments at store
      can :show, Assignment do |a|
        a.store == employee.current_assignment.store
      end

      # they can read their own profile and employees at store
      can :show, Employee do |e|
        e.current_assignment.store == employee.current_assignment.store
      end

      # they can update their own profile and employees at store
      can :update, Employee do |e|
        e.current_assignment.store_id == employee.current_assignment.store_id
      end

      # they can update their own profile and employees at store
      can :edit, Employee do |e|
        e.current_assignment.store_id == employee.current_assignment.store_id
      end


    elsif employee.role? :employee

      can :index, Assignment

      # they can read their own data
      can :show, Employee do |this_employee|
        employee == this_employee
      end

      # they can edit their own data
      can :edit, Employee do |this_employee|
        employee == this_employee
      end

      # they can update their own data
      can :update, Employee do |this_employee|
        employee == this_employee
      end

      # they can read their own assignment
      can :show, Assignment do |a|
        employee.current_assignment.id == a.id
      end

    else
      # guests can only read home page
    end
  end
end
