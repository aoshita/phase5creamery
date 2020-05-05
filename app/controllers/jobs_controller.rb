class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource


  def index
    # get data on all jobs and paginate the output to 10 per page
    @jobs = Job.alphabetical.paginate(page: params[:page]).per_page(10)
    @active_jobs = Job.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_jobs = Job.inactive.alphabetical.paginate(page: params[:ipage]).per_page(10)
  end

  def show
    retrieve_top_performing_employees
    @stores = Store.active.alphabetical
  end

  def new
    @job = Job.new
  end

  def edit
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to @job, notice: "Successfully added #{@job.name} to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @job.update_attributes(job_params)
      redirect_to @job, notice: "Updated job information for #{@job.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_path, notice: "Removed job from the system."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  def retrieve_top_performing_employees
    @top_performers = @job.shifts.for_past_days(91).map { |s| s.employee}.group_by{|i| i.id}.sort_by{ |k,v| [v.size*-1, v[0].name] }.take(10)
    #.joins(:assignment, :employee).select(:employee_id).group(:employee_id).count#to_a.map { |s| s. }#.select{|s|}
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def job_params
    params.require(:job).permit(:name, :description, :active)
  end

end
