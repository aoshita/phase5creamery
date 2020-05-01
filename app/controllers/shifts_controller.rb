class ShiftsController < ApplicationController

  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource


  def index
    # get data on all shifts and paginate the output to 10 per page
    @upcoming_shifts = Shift.upcoming.chronological.paginate(page: params[:page]).per_page(10)
    @completed_shifts = Shift.completed.chronological.paginate(page: params[:ipage]).per_page(10)
  end

  def show
    @jobs_completed = @shift.jobs.all.sort_by{|j| j.name}
    #@shift_jobs = ShiftJob.find(params[:shift_id])
  end

  def new
    @shift = Shift.new
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to @shift, notice: "Successfully added shift to the system."
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_shift
    @shift = Shift.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes, :status)
  end

end
