class HomeController < ApplicationController
  def index
    @employee = current_employee
    @active_stores = Store.active.alphabetical
    @past_shifts = Shift.for_past_days(7).by_store.chronological.paginate(page: params[:page]).per_page(10)
    @upcoming_shifts = Shift.for_next_days(7).by_store.chronological.paginate(page: params[:page]).per_page(10)
  end

  def about
  end

  def contact
  end

  def privacy
  end

end
