class PayrollsController < ApplicationController

  def store_pay_form
    @store = Store.find(params[:id])
  end

  def store_calc
    sd = params[:start]
    ed = params[:end]
    store = Store.find(params[:store_id])
    date_range = DateRange.new(sd,ed)
    calc = PayrollCalc.new(date_range)
    calc.get_store
  end

  def emp_pay
    emp = Employee.find(params[:id])
    date_range = DateRange.new(14.days.ago)
    calc = PayrollCalc.new(date_range)
    calc.get_employee
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
