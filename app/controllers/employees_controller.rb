class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index
    # for phase 3 only
    #if logged_in? and current_user.role == 'admin'
      @active_managers = Employee.managers.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @active_employees = Employee.regulars.active.alphabetical.paginate(page: params[:ipage]).per_page(10)
      @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:ipage]).per_page(10)
    #elsif logged_in? and current_user.role == 'manager' and !current_user.current_assignment.nil?
      # store = current_user.current_assignment.store
      # @active_managers = store.employees.managers.active.alphabetical.paginate(page: params[:page]).per_page(10)
      # @active_employees = store.employees.regulars.active.alphabetical.paginate(page: params[:page]).per_page(10)
      # @inactive_employees = store.employees.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    #end
  end

  def show
    retrieve_employee_assignments
    retrieve_employee_shifts
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: "Successfully added #{@employee.proper_name} as an employee."
    else
      render action: 'new'
    end
  end

  def update
    if @employee.update_attributes(employee_params)
      redirect_to @employee, notice: "Updated #{@employee.proper_name}'s information."
    else
      render action: 'edit'
    end
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :phone, :date_of_birth, :role, :active, :username, :password, :password_confirmation)
  end

  def retrieve_employee_assignments
    @current_assignment = @employee.current_assignment
    @previous_assignments = @employee.assignments.to_a - [@current_assignment]
  end

  def retrieve_employee_shifts
    @past_shifts = @employee.shifts.for_past_days(7)
    @upcoming_shifts = @employee.shifts.for_next_days(7)
  end

end
