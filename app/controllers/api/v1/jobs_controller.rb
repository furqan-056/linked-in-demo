class Api::V1::JobsController < Api::BaseController
  before_action :set_job, only: %i[show update destroy]
  before_action :authorize_job, only: %i[show update destroy]

  def index
    jobs = policy_scope(Job)
    render json: serialized_jobs(jobs)
  end

  def show
    render json: serialized_job(@job)
  end

  def create
    company = Company.find_by(id: params[:company_id])
    job = company.jobs.build(job_params)

    authorize job

    raise JobError.new(job) unless job.save
    render json: { message: ResourceMessages.for_success(:job, :created), job: serialized_job(job) }, status: :created
  end

  def update
    raise JobError.new(@job) unless @job.update(job_params)
    render json: { message: ResourceMessages.for_success(:job, :updated), job: serialized_job(@job) }
  end

  def destroy
    @job.destroy
    render json: { message: ResourceMessages.for_success(:job, :deleted) }
  end

  private

  def set_job
    @job = Job.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: ResourceMessages.for_error(:job, :not_found) }, status: :not_found
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

  def serialized_jobs(jobs)
    jobs.map { |job| serialized_job(job) }
  end
end
