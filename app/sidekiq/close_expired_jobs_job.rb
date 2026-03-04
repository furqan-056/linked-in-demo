class CloseExpiredJobsJob < ApplicationJob
  queue_as :default

  def perform
    Job.where("expiry_date < ? AND status != ?", Time.current, Job.statuses[:closed]).find_each do |job|
      job.update(status: :closed)
      Rails.logger.info "Closed expired job ##{job.id} - #{job.title}"
    end
  end
end
