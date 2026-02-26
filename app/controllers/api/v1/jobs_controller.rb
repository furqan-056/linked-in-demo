class Api::V1::JobsController < Api::BaseController
  before_action :set_job, only: [:show, :update, :destroy]
  before_action :authorize_job, only: [:show, :update, :destroy]

  def index
    jobs = policy_scope(Job)
    render json: serialized_jobs(jobs)
  end

  def show
    render json: serialized_job(@job)
  end

  def create
    company = Company.find_by(id: params[:company_id])
    raise ActiveRecord::RecordNotFound, "Company not found" unless company

    job = company.jobs.build(job_params)
    authorize job

    raise JobError, job.errors.full_messages.join(", ") unless job.save

    render json: { message: "Job created", job: serialized_job(job) }, status: :created
  end

  def update
    raise JobError, @job.errors.full_messages.join(", ") unless @job.update(job_params)

    render json: { message: "Job updated", job: serialized_job(@job) }
  end

  def destroy
    @job.destroy
    render json: { message: "Job deleted" }
  end

  private

  def set_job
    @job = Job.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Job not found" }, status: :not_found
  end

  def job_params
    params.permit(:title, :description, :salary, :location, :expiry_date, :status)
  end

  def authorize_job
    authorize @job
  end

  def serialized_job(job)
    JobSerializer.new(job).serializable_hash[:data][:attributes]
  end

  def serialized_jobs(jobs)
    jobs.map { |job| serialized_job(job) }
  end
end
