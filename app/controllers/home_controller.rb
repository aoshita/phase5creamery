class HomeController < ApplicationController
  def index
    @active_stores = Store.active.alphabetical
    @upcoming_shifts = Shift.for_next_days(7).by_store.chronological.paginate(page: params[:page]).per_page(10)
  end

  def about
  end

  def contact
  end

  def privacy
  end

end
