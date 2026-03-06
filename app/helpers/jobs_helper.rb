module JobsHelper
  def job_status_class(job)
    job.open? ? "job-status-open" : "job-status-closed"
  end

  def applied_notice_class(job, current_user)
    if current_user.job_applications.exists?(job: job)
      "notice notice-green"
    else
      ""
    end
  end
end
