class HomeController < ApplicationController
  def index
    @employee = current_user
    store = @employee.current_assignment.store if logged_in?
    @active_stores = Store.active.alphabetical
    if !logged_in?
    elsif current_user.role == 'admin'
      @past_shifts = Shift.for_past_days(7).by_employee.chronological.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.for_next_days(7).by_employee.chronological.paginate(page: params[:page]).per_page(10)
    elsif current_user.role == 'manager' and !store.nil?
      @past_shifts = Shift.for_past_days(7).for_store(store).chronological.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.for_next_days(7).for_store(store).chronological.paginate(page: params[:page]).per_page(10)
    elsif  current_user.role == 'employee'

      @past_shifts = Shift.for_past_days(7).for_employee(@employee).chronological.paginate(page: params[:page]).per_page(10)
      @upcoming_shifts = Shift.for_next_days(7).for_employee(@employee).chronological.paginate(page: params[:page]).per_page(10)
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end

end
