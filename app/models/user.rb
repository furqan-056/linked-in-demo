class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :companies, dependent: :destroy
  has_many :job_applications
  has_many :applied_jobs, through: :job_applications, source: :job

  enum :role, { admin: 0, recruiter: 1, candidate: 2 }

  validates :role, presence: true

  def admin?
    role == 'admin'
  end

  def recruiter?
    role == 'recruiter'
  end

  def candidate?
    role == 'candidate'
  end
end
