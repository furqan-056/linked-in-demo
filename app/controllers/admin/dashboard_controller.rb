module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def index
      @companies_count = Company.count
      @jobs_count = Job.count
      @jobs_by_day = Job.where('created_at >= ?', 7.days.ago).group('DATE(created_at)').order('DATE(created_at)').count

      @open_jobs_count = Job.where(status: 0).count
      @closed_jobs_count = Job.where(status: 1).count
      @jobs_by_status_chart = [["Open", @open_jobs_count], ["Closed", @closed_jobs_count]]

      @companies_by_industry = Company.group(:industry).count
    end

    private

    def authorize_admin!
      redirect_to root_path, alert: 'Access denied' unless current_user.admin?
    end
  end
end
