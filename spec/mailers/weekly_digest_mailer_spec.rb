require "rails_helper"

RSpec.describe WeeklyDigestMailer, type: :mailer do
  describe '#weekly_jobs' do
    let(:user) { create(:user, email: 'user@example.com') }

    context 'when there are open jobs in the last week' do
      let!(:company) { create(:company) }
      let!(:job) { create(:job, company: company, status: :open, created_at: 2.days.ago) }

      let(:mail) { WeeklyDigestMailer.weekly_jobs(user.id) }

      it 'renders the headers' do
        expect(mail.subject).to eq('Your Weekly Job Digest')
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(['no-reply@linkedindemo.com'])
      end

      it 'renders the body with job titles' do
        expect(mail.body.encoded).to include(job.title)
        expect(mail.body.encoded).to include(company.name)
      end
    end
  end
end
