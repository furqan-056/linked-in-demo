require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:recruiter) { create(:user, :recruiter) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    context 'when user is a recruiter' do
      before do
        sign_in recruiter
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is a regular user' do
      before do
        sign_in user
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
