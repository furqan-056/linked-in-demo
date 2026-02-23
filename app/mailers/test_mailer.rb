class TestMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def welcome_email(user_email)
    mail(
      to: user_email,
      subject: 'Welcome to LinkedIn Demo!'
    )
  end
end
