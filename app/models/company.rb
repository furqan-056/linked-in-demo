class Company < ApplicationRecord
  belongs_to :user
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :industry, :website, presence: true
end
