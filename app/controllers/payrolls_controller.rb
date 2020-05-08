class PayrollsController < ApplicationController
  before_action :check_login
  authorize_resource
  
  def store_pay_form
    @store = Store.find(params[:id])
  end

  def store_calc
    sd = params[:employee][:start_date]
    ed = params[:employee][:end_date]
    s_id = params[:employee][:store_id]
    @store = Store.find_by(id: s_id)
    date_range = DateRange.new(sd.to_date,ed.to_date)
    calc = PayrollCalculator.new(date_range)
    @store_payrolls = calc.create_payrolls_for(@store)
  end

  def emp_pay
    emp = Employee.find(params[:id])
    date_range = DateRange.new(7.days.ago.to_date,Date.today)
    calc = PayrollCalculator.new(date_range)
    @emp_payroll = calc.create_payroll_record_for(emp)
  end

end
