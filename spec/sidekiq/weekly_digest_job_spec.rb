require 'rails_helper'

RSpec.describe WeeklyDigestJob, type: :job do
  let!(:candidate1) { create(:user, role: :candidate) }
  let!(:candidate2) { create(:user, role: :candidate) }
  let!(:recruiter1)   { create(:user, role: :recruiter) }

  describe '#perform' do
    it 'sends weekly digest emails to all candidates' do

      allow(WeeklyDigestMailer).to receive_message_chain(:weekly_jobs, :deliver_later)

      described_class.perform_now

      expect(WeeklyDigestMailer).to have_received(:weekly_jobs).with(candidate1.id)
      expect(WeeklyDigestMailer).to have_received(:weekly_jobs).with(candidate2.id)
      expect(WeeklyDigestMailer).not_to have_received(:weekly_jobs).with(recruiter1.id)
    end
  end

  describe 'queue' do
    it 'is in the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
