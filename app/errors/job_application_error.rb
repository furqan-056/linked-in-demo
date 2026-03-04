class JobApplicationError < StandardError
  attr_reader :errors

  def initialize(job_application)
    @errors = job_application.errors.full_messages
    super(@errors.present? ? @errors.join(", ") : 'JobApplication operation failed')
  end
end
