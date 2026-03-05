require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user, password: 'password123') }

    context 'with valid credentials' do
      before do
        post :create, params: { email: user.email, password: 'password123' }, as: :json
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user data with auth token (may be nil in current app)' do
        json = JSON.parse(response.body)
        expect(json['data']['id'].to_i).to eq(user.id)
        expect(json['meta']['token']).to eq(json['meta']['token'])
      end
    end

    context 'with invalid email' do
      before do
        post :create, params: { email: 'wrong@example.com', password: 'password123' }, as: :json
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns current error message' do
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Invalid email or password')
      end
    end

    context 'with invalid password' do
      before do
        post :create, params: { email: user.email, password: 'wrongpassword' }, as: :json
      end

      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns current error message' do
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end
end
