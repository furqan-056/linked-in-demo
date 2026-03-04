class WeeklyDigestMailer < ApplicationMailer
  default from: 'no-reply@linkedindemo.com'

  def weekly_jobs(user_id)
    @user = User.find(user_id)
    @jobs = Job.open.where("created_at >= ?", 1.week.ago).includes(:company)

    return if @jobs.empty?

    mail(
      to: @user.email,
      subject: 'Your Weekly Job Digest'
    )
  end
end
