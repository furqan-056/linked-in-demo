class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  enum :status, { applied: 0, reviewing: 1, rejected: 2, interview: 3 }

  validates :user_id, uniqueness: { scope: :job_id, message: 'has already applied to this job' }
  validates :user, :job, :status, presence: true
  after_update :send_status_email, if: :saved_change_to_status?


  private

  def send_status_email
    case status
    when 'interview'
      UserMailer.interview_scheduled(self).deliver_later
    when 'reviewing', 'rejected'
      UserMailer.interview_status_update(self).deliver_later
    end
  end
end
