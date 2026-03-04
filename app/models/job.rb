class Job < ApplicationRecord
  belongs_to :company
  validates :company, presence: true

  has_many :job_applications
  has_many :candidates, through: :job_applications, source: :user

  enum :status, { open: 0, closed: 1, paused: 2 }

  validates :title, :description, :salary, :location, :expiry_date, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }
end
