class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.recruiter?
      @jobs = policy_scope(Job).where(company: current_user.companies)
      @companies = policy_scope(Company).where(user: current_user)
      @applications = JobApplication.joins(:job).merge(@jobs)
    else
      @jobs = policy_scope(Job)
      @companies = policy_scope(Company)
      @applications = current_user.job_applications.includes(job: :company)
    end
  end
end
