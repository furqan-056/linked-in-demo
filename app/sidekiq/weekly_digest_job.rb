class WeeklyDigestJob < ApplicationJob
  queue_as :default

  def perform
    candidates = User.where(role: :candidate)
    candidates.find_each do |user|
      WeeklyDigestMailer.weekly_jobs(user.id).deliver_later
    end
  end
end
