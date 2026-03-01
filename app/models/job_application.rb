class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  enum :status, { applied: 0, reviewing: 1, rejected: 2, interview: 3 }

  validates :user_id, uniqueness: { scope: :job_id, message: 'has already applied to this job' }
  validates :user, :job, :status, presence: true
end
