class ShiftJobsController < ApplicationController

  before_action :set_shift_job, only: [:destroy]
  before_action :check_login
  authorize_resource

  def new
    @shift_job = ShiftJob.new
    @shift     = Shift.find(params[:shift_id])
    @shift_job.shift = @shift
    #@shift_job.shift_id = params[:shift_id] unless params[:shift_id].nil?
  end

  def create
    @shift_job = ShiftJob.new(shift_job_params)
    if @shift_job.save
      redirect_to shift_path(@shift_job.shift), notice: "Successfully added #{@shift_job.job.name} to #{@shift_job.shift.employee.name}'s shift'."
    else
      #@shift = Shift.find(params[:shift_job][:shift_id])
      render action: 'new'#, locals: {shift: @shift}
    end
  end

  def destroy
    @shift     = Shift.find(params[:shift_id])
    if @shift_job.destroy
      redirect_to shift_path(@shift), notice: "Removed from #{@shift.employee.name}'s shift."
    else

      render action: 'show'
    end

    #redirect_to shift_path(@shift)
    # else
      #redirect_to shift_path(@shift_job.shift

  end


  private
  # Use callbacks to share common setup or constraints between actions.
    def set_shift_job
      @shift_job = ShiftJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shift_job_params
      params.require(:shift_job).permit(:shift_id, :job_id)
    end

end
