class JobsController < ApplicationController

  before_action :set_job, only: [:show, :edit, :update, :destroy]


  def index
    # get data on all jobs and paginate the output to 10 per page
    @jobs = Job.sort_by{|j| j.name}.paginate(page: params[:page]).per_page(10)
    @active_jobs = Job.active.sort_by{|j| j.name}.paginate(page: params[:page]).per_page(10)
    @inactice_jobs = Job.inactive.sort_by{|j| j.name}.paginate(page: params[:page]).per_page(10)
  end

  def show
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_params
    params.require(:job).permit(:name, :description, :active)
  end

end
