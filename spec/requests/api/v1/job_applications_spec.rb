require 'rails_helper'

RSpec.describe 'Api::V1::JobApplications', type: :request do
  let(:candidate) { create(:user, role: 'candidate') }
  let(:recruiter) { create(:user, role: 'recruiter') }
  let(:admin) { create(:user, role: 'admin') }

  let(:candidate_token) { JWT.encode({ user_id: candidate.id }, Rails.application.credentials.jwt_secret_key, 'HS256') }
  let(:recruiter_token) { JWT.encode({ user_id: recruiter.id }, Rails.application.credentials.jwt_secret_key, 'HS256') }
  let(:admin_token) { JWT.encode({ user_id: admin.id }, Rails.application.credentials.jwt_secret_key, 'HS256') }

  let(:candidate_headers) { { 'Authorization' => "Bearer #{candidate_token}" } }
  let(:recruiter_headers) { { 'Authorization' => "Bearer #{recruiter_token}" } }
  let(:admin_headers) { { 'Authorization' => "Bearer #{admin_token}" } }

  let!(:company) { create(:company, user: recruiter) }
  let!(:job) { create(:job, company: company) }

  describe 'POST /api/v1/job_applications' do
    it 'allows candidate to apply for a job' do
      post '/api/v1/job_applications', params: { job_id: job.id }, headers: candidate_headers
      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['message']).to eq('Applied for job successfully')
      expect(body['application']['job_title']).to eq(job.title)
    end

    it 'returns 404 if job does not exist' do
      post '/api/v1/job_applications', params: { job_id: 999 }, headers: candidate_headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Job not found')
    end

    it 'prevents recruiter from applying' do
      post '/api/v1/job_applications', params: { job_id: job.id }, headers: recruiter_headers
      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)['error']).to eq('Forbidden')
    end
  end

  describe 'PATCH /api/v1/job_applications/:id' do
    let!(:application) { create(:job_application, user: candidate, job: job) }

    it 'allows recruiter to update application status' do
      patch "/api/v1/job_applications/#{application.id}", params: { status: 'reviewing' }, headers: recruiter_headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['message']).to eq('Application status updated')
      expect(body['application']['status']).to eq('reviewing')
    end

    it 'prevents candidate from updating status' do
      patch "/api/v1/job_applications/#{application.id}", params: { status: 'reviewing' }, headers: candidate_headers
      expect(response).to have_http_status(:forbidden)
      expect(JSON.parse(response.body)['error']).to eq('Forbidden')
    end
  end

  describe 'GET /api/v1/job_applications/:id' do
    let!(:application) { create(:job_application, user: candidate, job: job) }

    it 'returns application for candidate' do
      get "/api/v1/job_applications/#{application.id}", headers: candidate_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['candidate_email']).to eq(candidate.email)
    end

    it 'returns application for recruiter if belongs to their company' do
      get "/api/v1/job_applications/#{application.id}", headers: recruiter_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['company_name']).to eq(company.name)
    end

    it 'returns 404 if application does not exist' do
      get '/api/v1/job_applications/999', headers: admin_headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Application not found')
    end
  end
end
