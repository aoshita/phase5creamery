class ShiftJobsController < ApplicationController

  before_action :set_shift_job, only: [:destroy]

  def new
    @shift_job = ShiftJob.new
  end

  def create
    @shift_job = ShiftJob.new(shift_job_params)
    if @shift_job.save
      redirect_to shift_path(@shift_job.shift), notice: "Successfully added #{@shift_job.job.name} to #{@shift_job.shift.employee.name}'s shift'."
    else
      render action: 'new'
    end
  end

  def destroy
    if @shift_job.destroy
      redirect_to shift_path(@shift_job.shift), notice: "Removed #{@shift_job.job.name} from #{@shift_job.shift.employee.name}'s shift."
    # else
      #redirect_to shift_path(@shift_job.shift
    end
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
