class ShiftsController < ApplicationController

  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource


  def index
    # get data on all shifts and paginate the output to 10 per page\
    @stores = Store.active.alphabetical.to_a
    if logged_in? and current_user.role == 'employee'
      @upcoming_shifts = current_user.shifts.upcoming.chronological.paginate(page: params[:page]).per_page(10)
      @completed_shifts = current_user.shifts.completed.chronological.paginate(page: params[:ipage]).per_page(10)
    else

      if current_user.role?(:manager)
        @store = current_user.current_assignment.store
        # s_loc = @stores.index(store)
        # @stores.insert(0, @stores.delete_at(s_loc))
      else
        @store = @stores[0]
      end
      @upcoming_shifts = Shift.upcoming.chronological.paginate(page: params[:page]).per_page(10)
      @completed_shifts = Shift.completed.chronological.paginate(page: params[:ipage]).per_page(10)
    end
  end

  def show
    @jobs_completed = @shift.jobs.all.sort_by{|j| j.name}
    #@shift_jobs = ShiftJob.find(params[:shift_id])
  end

  def new
    @shift = Shift.new
    @shift.assignment_id = params[:assignment_id] unless params[:assignment_id].nil?
    get_time_options
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to home_path, notice: "Successfully added shift to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @shift.update_attributes(shift_params)
      redirect_to @shift, notice: "Updated shift information for #{@shift.name}."
    else
      render action: 'edit'
    end
  end


  def destroy
    name = @shift.employee.proper_name
    date = @shift.date.strftime('%b %d, %Y')
    @shift.destroy
    redirect_to shifts_path, notice: "Removed #{name}'s shift on #{date}"
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_shift
    @shift = Shift.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes, :status)
  end

  def get_time_options
  end

end
