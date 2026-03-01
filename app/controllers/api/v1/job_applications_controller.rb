class Api::V1::JobApplicationsController < Api::BaseController
  before_action :set_job_application, only: %i[show update]
  before_action :authorize_job_application, only: %i[show update]

  def index
    applications = policy_scope(JobApplication)
    render json: applications.map { |app| serialized_job_application(app) }
  end

  def show
    render json: serialized_job_application(@job_application)
  end

  def create
    job = Job.find_by(id: params[:job_id])
    return render json: { error: 'Job not found' }, status: :not_found unless job

    application = JobApplication.new(user: current_user, job: job, status: :applied)
    authorize application

    raise JobApplicationError.new(application) unless application.save
    render json: { message: 'Applied for job successfully', application: serialized_job_application(application) }, status: :created
  end

  def update
    if @job_application.update(status: params[:status])
      render json: { message: 'Application status updated', application: serialized_job_application(@job_application) }
    else
      render json: { error: @job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Application not found' }, status: :not_found
  end

  def authorize_job_application
    authorize @job_application
  end

  def serialized_job_application(application)
    JobApplicationSerializer.new(application).serializable_hash.dig(:data, :attributes)
  end
end
