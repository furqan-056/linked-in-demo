class NightlyReindexJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting nightly reindex of Jobs at #{Time.current}"

    begin
      Job.reindex
      total = Job.search_index.total_docs rescue 'N/A'
      Rails.logger.info "Reindex completed successfully. Total jobs indexed: #{total}"
    rescue => e
      Rails.logger.error "Reindex failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
