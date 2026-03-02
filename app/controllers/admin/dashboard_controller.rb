module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    def index
      @companies_count = Company.count
      @jobs_count = Job.count
    end

    private

    def authorize_admin!
      redirect_to root_path, alert: 'Access denied' unless current_user.admin?
    end
  end
end
