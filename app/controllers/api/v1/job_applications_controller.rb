class Api::V1::JobApplicationsController < Api::BaseController
  before_action :set_job_application, only: %i[show update]
  before_action :authorize_job_application, only: %i[show update]
  before_action :set_job, only: %i[create]

  def index
    applications = policy_scope(JobApplication)
    render json: applications.map { |app| serialized_job_application(app) }
  end

  def show
    render json: serialized_job_application(@job_application)
  end

  def create
    application = JobApplication.new(user: current_user, job: @job, status: :applied)
    authorize application

    raise JobApplicationError.new(application) unless application.save
    render json: { message: 'Applied for job successfully', application: serialized_job_application(application) }, status: :created
  end

  def update
    raise JobApplicationError.new(@job_application) unless @job_application.update(status: params[:status])
    render json: { message: 'Application status updated', application: serialized_job_application(@job_application) }, status: :ok
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def authorize_job_application
    authorize @job_application
  end

  def serialized_job_application(application)
    JobApplicationSerializer.new(application).serializable_hash.dig(:data, :attributes)
  end

  def set_job
    @job = Job.find_by(id: params[:job_id])
    return render json: { error: 'Job not found' }, status: :not_found unless @job.present?
  end
end
