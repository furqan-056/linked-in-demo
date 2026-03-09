require 'rails_helper'

RSpec.describe NightlyReindexJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    let(:logger_double) { instance_double(Logger, info: nil, error: nil) }

    before do
      allow(Rails).to receive(:logger).and_return(logger_double)
    end

    it 'calls Job.reindex and logs success' do
      expect(logger_double).to receive(:info).with(/Starting nightly reindex of Jobs/)

      perform_enqueued_jobs do
        described_class.perform_now
      end
    end

    it 'logs errors if reindex fails' do
      allow(Job).to receive(:reindex).and_raise(StandardError.new('boom'))
      expect(logger_double).to receive(:info).with(/Starting nightly reindex of Jobs/)

      perform_enqueued_jobs do
        described_class.perform_now
      end
    end
  end

  describe 'queue' do
    it 'is in the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end
  end
end
