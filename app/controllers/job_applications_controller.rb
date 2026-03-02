class JobApplicationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @job = Job.find(params[:job_id])
    unless current_user.job_applications.exists?(job: @job)
      @application = current_user.job_applications.create(job: @job, status: :applied)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to job_path(@job), notice: "Applied successfully" }
    end
  end
end
