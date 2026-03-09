require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) do
      {
        email: Faker::Internet.unique.email,
        password: 'password123',
        password_confirmation: 'password123',
        role: 'candidate'
      }
    end

    let(:invalid_params) do
      {
        email: 'invalidemail',
        password: '123',
        password_confirmation: '321',
        role: 'candidate'
      }
    end

    context 'with valid params' do
      before do
        post :create, params: valid_params, as: :json
      end

      it 'returns status created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      before do
        post :create, params: invalid_params, as: :json
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
