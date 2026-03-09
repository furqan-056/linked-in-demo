require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }

  describe 'GET #index' do
    context 'when admin user is signed in' do
      before do
        sign_in admin_user
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when regular user is signed in' do
      before do
        sign_in regular_user
        get :index
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets an alert message' do
        expect(flash[:alert]).to eq('Access denied')
      end
    end
  end
end
