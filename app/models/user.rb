class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :companies, dependent: :destroy

  enum :role, { admin: 0, recruiter: 1, candidate: 2 }

  validates :role, presence: true
end
