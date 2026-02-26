require 'rails_helper'

RSpec.describe "Api::V1::Jobs", type: :request do
  let(:user) { create(:user, role: "recruiter") }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_secret_key, 'HS256') }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let!(:company) { create(:company, user: user) }
  let!(:job) { create(:job, company: company) }

  describe "GET /index" do
    it "returns all jobs" do
      get "/api/v1/jobs", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["id"]).to eq(job.id)
    end
  end

  describe "GET /show" do
    context "when job exists" do
      it "returns the job" do
        get "/api/v1/jobs/#{job.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["id"]).to eq(job.id)
      end
    end

    context "when job does not exist" do
      it "returns not found" do
        get "/api/v1/jobs/999", headers: headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Job not found")
      end
    end
  end

  describe "POST /create" do
    let(:valid_params) { { title: "Dev", description: "Ruby Dev", salary: 1000, location: "Remote", expiry_date: 1.month.from_now, status: "open", company_id: company.id } }
    let(:invalid_params) { { title: "" , company_id: company.id } }

    it "creates a job with valid params" do
      post "/api/v1/jobs", params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["job"]["title"]).to eq("Dev")
    end

    it "returns error with invalid params" do
      post "/api/v1/jobs", params: invalid_params, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end

  describe "PATCH /update" do
    it "updates a job with valid params" do
      patch "/api/v1/jobs/#{job.id}", params: { title: "Updated Dev" }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["job"]["title"]).to eq("Updated Dev")
    end

    it "returns error with invalid params" do
      patch "/api/v1/jobs/#{job.id}", params: { title: "" }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to be_present
    end
  end

  describe "DELETE /destroy" do
    it "deletes the job" do
      delete "/api/v1/jobs/#{job.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Job deleted")
    end
  end

  describe "Authorization" do
    it "returns unauthorized without token" do
      get "/api/v1/jobs"
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Authorization token missing")
    end
  end
end
