class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: %i[create]

  def create
    @application = current_user.job_applications.new(job: @job, status: :applied)

    if @application.save
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to job_path(@job), alert: @application.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end
end
