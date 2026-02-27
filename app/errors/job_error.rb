class JobError < StandardError
  attr_reader :errors

  def initialize(job)
    @errors = job.errors.full_messages
    super(@errors.present? ? @errors.join(", ") : 'Job operation failed')
  end
end
