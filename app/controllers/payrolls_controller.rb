class PayrollsController < ApplicationController
  def store_pay_form
    @store = Store.find(params[:id])
  end

  def store_calc
    sd = params[:start]
    ed = params[:end]
    @store = Store.find(params[:store_id])
    date_range = DateRange.new(sd,ed)
    calc = PayrollCalculator.new(date_range)
    @store_payrolls = calc.create_payroll_for(@store)
  end

  def emp_pay
    emp = Employee.find(params[:id])
    date_range = DateRange.new(7.days.ago)
    calc = PayrollCalculator.new(date_range)
    @emp_payroll = calc.create_payroll_record_for(emp)
  end

  private
  def store_params
    params.require(:store).permit(:name, :street, :city, :phone, :state, :zip, :active)
  end

  def calc_params
    params.require(:store).permit()
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :phone, :date_of_birth, :role, :active, :username, :password, :password_confirmation)
  end

end
