require 'rails_helper'

RSpec.describe CloseExpiredJobsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:expired_job) { create(:job, expiry_date: 2.days.ago, status: :open) }
  let!(:active_job) { create(:job, expiry_date: 2.days.from_now, status: :open) }
  let!(:already_closed_job) { create(:job, expiry_date: 5.days.ago, status: :closed) }

  describe '#perform' do
    it 'closes expired jobs' do
      expect(expired_job.status).to eq('open')
      expect(already_closed_job.status).to eq('closed')

      perform_enqueued_jobs do
        described_class.perform_now
      end

      expired_job.reload
      active_job.reload
      already_closed_job.reload

      expect(expired_job.status).to eq('closed')
      expect(active_job.status).to eq('open')
      expect(already_closed_job.status).to eq('closed')
    end
  end

  describe 'queue' do
    it 'is in the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
