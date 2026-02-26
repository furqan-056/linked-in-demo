class JobError < StandardError
  def initialize(msg = "Job operation failed")
    super
  end
end
