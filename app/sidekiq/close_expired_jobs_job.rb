class CloseExpiredJobsJob < ApplicationJob
  queue_as :default

  def perform
    updated_count = Job.where("expiry_date < ? AND status != ?", Time.current, Job.statuses[:closed]).update_all(status: :closed)
    Rails.logger.info "Closed #{updated_count} expired jobs"
  end
end
