class Api::V1::JobsController < Api::BaseController
  before_action :set_job, only: %i[show update destroy]
  before_action :authorize_job, only: %i[show update destroy]
  before_action :set_company, only: %i[create]

  def index
    jobs = policy_scope(Job)
    render json: jobs.map { |job| serialized_job(job) }
  end

  def show
    render json: serialized_job(@job)
  end

  def create
    job = Job.new(job_params.merge(company_id: @company.id))
    authorize job

    raise JobError.new(job) unless job.save
    render json: { message: 'Job created', job: serialized_job(job) }, status: :created
  end

  def update
    raise JobError.new(@job) unless @job.update(job_params)
    render json: { message: 'Job updated', job: serialized_job(@job) }, status: :ok
  end

  def destroy
    if @job.destroy
      render json: { message: 'Job Removed' }, status: :ok
    else
      render json: { error: 'Failed to delete job' }, status: :unprocessable_entity
    end
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.permit(:title, :description, :salary, :location, :expiry_date, :status)
  end

  def authorize_job
    authorize @job
  end

  def serialized_job(job)
    JobSerializer.new(job).serializable_hash.dig(:data, :attributes)
  end

  def set_company
    @company = Company.find_by(id: params[:company_id])
    return render json: { error: 'Company not found' }, status: :not_found unless @company.present?
  end
end
