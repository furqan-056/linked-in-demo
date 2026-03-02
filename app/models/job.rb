class Job < ApplicationRecord
  searchkick word_middle: [:title, :location], text_middle: [:description]
  belongs_to :company
  validates :company, presence: true

  has_many :job_applications
  has_many :candidates, through: :job_applications, source: :user

  enum :status, { open: 0, closed: 1, paused: 2 }

  validates :title, :description, :salary, :location, :expiry_date, presence: true
  validates :salary, numericality: { greater_than_or_equal_to: 0 }

  def search_data
    {
      title: title,
      description: description,
      location: location,
      salary: salary,
      status: status,
      company_name: company&.name,
      company_industry: company&.industry,
      expiry_date: expiry_date,
      created_at: created_at
    }
  end

  def should_index?
    open?
  end
end
