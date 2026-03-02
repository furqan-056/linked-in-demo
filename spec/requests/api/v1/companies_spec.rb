require 'rails_helper'

RSpec.describe 'Api::V1::Companies', type: :request do
  let(:user) { create(:user, role: 'recruiter') }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_secret_key, 'HS256') }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let!(:company) { create(:company, user: user) }

  describe 'GET /index' do
    it 'returns all companies' do
      get '/api/v1/companies', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first['id']).to eq(company.id)
    end
  end

  describe 'GET /show' do
    context 'when company exists' do
      it 'returns the company' do
        get "/api/v1/companies/#{company.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(company.id)
      end
    end

    context 'when company does not exist' do
      it 'returns not found' do
        get '/api/v1/companies/999', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Company not found')
      end
    end
  end

  describe 'POST /create' do
    let(:valid_params) { { name: 'NewCo', industry: 'Tech', website: 'https://newco.com' } }
    let(:invalid_params) { { name: '' } }

    it 'creates a company with valid params' do
      post '/api/v1/companies', params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['company']['name']).to eq('NewCo')
    end

    it 'returns error with invalid params' do
      post '/api/v1/companies', params: invalid_params, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to be_present
    end
  end

  describe 'PATCH /update' do
    let(:update_params) { { name: 'UpdatedCo' } }

    it 'updates the company' do
      patch "/api/v1/companies/#{company.id}", params: update_params, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['company']['name']).to eq('UpdatedCo')
    end

    it 'returns error with invalid params' do
      patch "/api/v1/companies/#{company.id}", params: { name: '' }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['error']).to be_present
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the company' do
      delete "/api/v1/companies/#{company.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Company deleted')
    end
  end

  describe 'Authorization' do
    it 'returns unauthorized without token' do
      get '/api/v1/companies'
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('Authorization token missing')
    end
  end
end
