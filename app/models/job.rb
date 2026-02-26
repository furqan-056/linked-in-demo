class Job < ApplicationRecord
  belongs_to :company

  enum :status, { open: 0, closed: 1, paused: 2 }

  validates :title, :description, :salary, :location, :expiry_date, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }
end
