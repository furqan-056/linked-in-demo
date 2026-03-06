class UserMailer < ApplicationMailer
  default from: 'no-reply@linkedindemo.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to LinkedIn Demo!')
  end

  def interview_scheduled(application)
    set_application(application)
    mail(to: @user.email, subject: 'Your interview is scheduled!')
  end

  def interview_status_update(application)
    set_application(application)
    mail(to: @user.email, subject: 'Update on your job application')
  end

  private

  def set_application(application)
    @application = application
    @user = application.user
    @job = application.job
  end
end
