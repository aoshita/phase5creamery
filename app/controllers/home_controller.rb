class HomeController < ApplicationController

  def index
    @employee = current_user
    @store = @employee.current_assignment.store unless !logged_in? || @employee.current_assignment.nil?
    @active_stores = Store.active.alphabetical
    if !logged_in?
    elsif current_user.role == 'admin'
      @past_shifts = Shift.for_past_days(7).chronological.by_store.by_employee.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.for_next_days(7).chronological.by_store.by_employee.paginate(page: params[:ipage]).per_page(10)
    elsif current_user.role == 'manager' and !@store.nil?
      @past_shifts = Shift.for_past_days(7).for_store(@store).chronological.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.for_next_days(7).for_store(@store).chronological.paginate(page: params[:ipage]).per_page(10)
      @current_employees = Assignment.current.for_store(@store).map { |a| a.employee }.select{ |e| e.role =='employee' }.sort_by{|e| e.name}
    elsif  current_user.role == 'employee'
      @past_shifts = Shift.for_past_days(7).for_employee(@employee).chronological.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.for_next_days(7).for_employee(@employee).chronological.paginate(page: params[:ipage]).per_page(10)
      @shift = @upcoming_shifts.for_next_days(0).take unless @upcoming_shifts.to_a.empty?
      # @shift = TimeClock.new(shift)
    end
  end

  def clock_in
    shift = Shift.find_by(id: params[:shift_id])
    shift.update_attribute(:start_time, Time.local(2000,1,1, Time.now.hour, Time.now.min, 0))
    shift.update_attribute(:status,'started')
    #shift.save
    flash[:notice] = "clocked in at #{shift.start_time.strftime("%l:%M%p")}"
    redirect_to home_path
  end

  def clock_out
    shift = Shift.find_by(id: params[:shift_id])
    shift.update_attribute(:end_time, Time.local(2000,1,1, Time.now.hour, Time.now.min, 0))
    shift.update_attribute(:status,'finished')
    #shift.save
    flash[:notice] = "clocked out at #{shift.end_time.strftime("$l:%M%p")}"
    redirect_to home_path
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
    redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    @employees = Employee.where.not(role: 'admin').search(@query)
    @total_hits = @employees.size
  end


end
