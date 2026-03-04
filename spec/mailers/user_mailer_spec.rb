require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let(:job) { create(:job, company: company) }
  let(:application) { create(:job_application, user: user, job: job) }

  describe '#welcome_email' do
    let(:mail) { UserMailer.welcome_email(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Welcome to LinkedIn Demo!')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@linkedindemo.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Welcome')
      expect(mail.body.encoded).to match(user.email)
    end
  end

  describe '#interview_scheduled' do
    let(:mail) { UserMailer.interview_scheduled(application) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your interview is scheduled!')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@linkedindemo.com'])
    end

    it 'assigns @user and @job' do
      expect(mail.body.encoded).to match("#{user.email}")
      expect(mail.body.encoded).to match("#{job.title}")
    end
  end

  describe '#interview_status_update' do
    let(:mail) { UserMailer.interview_status_update(application) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Update on your job application')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['no-reply@linkedindemo.com'])
    end

    it 'assigns @user, @job, and @application' do
      expect(mail.body.encoded).to match("#{application.status.humanize}")
    end
  end
end
